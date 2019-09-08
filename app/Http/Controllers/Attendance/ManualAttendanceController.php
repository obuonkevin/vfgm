<?php

namespace App\Http\Controllers\Attendance;

use App\Http\Controllers\Controller;

use App\Model\EmployeeAttendance;

use Illuminate\Support\Facades\DB;

use Illuminate\Http\Request;

use App\Model\Department;

use App\Model\Employee;

use Carbon\Carbon;


class ManualAttendanceController extends Controller
{

    public function manualAttendance()
	{
        $departmentList = Department::get();
        return view('admin.attendance.manualAttendance.index',['departmentList'=>$departmentList]);
    }



    public function filterData(Request $request)
	{
        $data           = dateConvertFormtoDB($request->get('date'));
        $department     = $request->get('department_id');
        $departmentList = Department::get();

        $attendanceData = Employee::select('employee.finger_id','employee.department_id',
                            DB::raw('CONCAT(COALESCE(employee.first_name,\'\'),\' \',COALESCE(employee.last_name,\'\')) as fullName'),

                            DB::raw('(SELECT DATE_FORMAT(MIN(view_employee_in_out_data.in_time), \'%h:%i %p\')  FROM view_employee_in_out_data
                                                             WHERE view_employee_in_out_data.date = "'.$data.'" AND view_employee_in_out_data.finger_print_id = employee.finger_id ) AS inTime'),

                            DB::raw('(SELECT DATE_FORMAT(MAX(view_employee_in_out_data.out_time), \'%h:%i %p\') FROM view_employee_in_out_data
                                                             WHERE view_employee_in_out_data.date =  "'.$data.'" AND view_employee_in_out_data.finger_print_id = employee.finger_id ) AS outTime'))
                            ->where('employee.department_id',$department)
                            ->where('employee.status',1)
                            ->get();

        return view('admin.attendance.manualAttendance.index',['departmentList'=>$departmentList,'attendanceData'=>$attendanceData]);
    }



    public function store(Request $request)
	{
        try{
            DB::beginTransaction();
                $data           = dateConvertFormtoDB($request->get('date'));
                $department     = $request->get('department_id');

                $result = json_decode(DB::table(DB::raw("(SELECT employee_attendance.*,employee.`department_id`,  DATE_FORMAT(`employee_attendance`.`in_out_time`,'%Y-%m-%d') AS `date` FROM `employee_attendance`
                    INNER JOIN `employee` ON `employee`.`finger_id` = employee_attendance.`finger_print_id`
                    WHERE department_id = $department) as employeeAttendance"))
                    ->select('employeeAttendance.employee_attendance_id')
                    ->where('employeeAttendance.date',$data)
                    ->get()->toJson(),true);

                DB::table('employee_attendance')->whereIn('employee_attendance_id',array_values($result))->delete();

                foreach ($request->finger_print_id as  $key => $finger_print_id)
                {
                    if(isset($request->inTime[$key]) && isset($request->outTime[$key])){
                        $InData = [
                            'finger_print_id'       => $finger_print_id,
                            'in_out_time'           => dateConvertFormtoDB($request->date). ' ' .date("H:i:s", strtotime($request->inTime[$key])),
                            'created_at'            => Carbon::now(),
                            'updated_at'            => Carbon::now(),
                        ];
                        EmployeeAttendance::insert($InData);

                        $outData = [
                            'finger_print_id'       => $finger_print_id,
                            'in_out_time'           =>dateConvertFormtoDB($request->date). ' ' .date("H:i:s", strtotime($request->outTime[$key])),
                            'created_at'            => Carbon::now(),
                            'updated_at'            => Carbon::now(),
                        ];
                        EmployeeAttendance::insert($outData);
                    } else if(isset($request->inTime[$key])){
                        $InData = [
                            'finger_print_id'       => $finger_print_id,
                            'in_out_time'           => dateConvertFormtoDB($request->date). ' ' .date("H:i:s", strtotime($request->inTime[$key])),
                            'created_at'            => Carbon::now(),
                            'updated_at'            => Carbon::now(),
                        ];
                        EmployeeAttendance::insert($InData);
                    }
                }
            DB::commit();
            $bug = 0;
        }
        catch(\Exception $e){
            DB::rollback();
            $bug = $e->errorInfo[1];
        }

        if($bug == 0){
            return redirect('manualAttendance')->with('success', 'Attendance successfully saved.');
        }else {
            return redirect('manualAttendance')->with('error', 'Something Error Found !, Please try again.');
        }
    }



}
