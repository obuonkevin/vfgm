<?php

namespace App\Repositories;

use App\Model\Market\Category;
use App\Model\Market\Vendor;
use App\Model\Role;

use App\Model\PayGrade;

use App\Model\WorkShift;

use App\Model\TrainingType;

use App\Model\Settings\Ward;



use App\Model\Settings\County;
use App\Model\Settings\Location;
use App\Model\Settings\SubCounty;
use App\Model\PerformanceCategory;
use Illuminate\Support\Facades\DB;
use League\Flysystem\Adapter\Local;

class CommonRepository
{

    public function roleList(){
        $results = Role::get();
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value->role_id] = $value->role_name;
        }
        return $options ;
    }

    public function countyList(){
        $results = County::get();
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value->county_id] = $value->county_name;
        }
        return $options ;
    }

    public function SubcountyList(){
        $results = SubCounty::get();
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value->sub_county_id] = $value->sub_county_name;
        }
        return $options ;
    }

    public function wardList(){
        $results = Ward::get();
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value->ward_id] = $value->ward_name;
        }
        return $options ;
    }

    public function locationList(){
        $results = Location::get();
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value->location_id] = $value->location_name;
        }
        return $options ;
    }


    public function userList(){
        $results = DB::table('user')->where('status',1)->get();
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value->user_id] = $value->user_name;
        }
        return $options ;
    }

    public function vendorList(){
        $results = Vendor::get();
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value->vendor_id] = $value->name;
        }
        return $options ;
    }

    public function categoryList(){
        $results = Category::get();
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value->category_id] = $value->category_name;
        }
        return $options ;
    }

    public function departmentList(){
        $results = DB::table('department')->get();
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value->department_id] = $value->department_name;
        }
        return $options ;
    }


    public function designationList(){
        $results = DB::table('designation')->get();
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value->designation_id] = $value->designation_name;
        }
        return $options ;
    }


    public function branchList(){
        $results = DB::table('branch')->get();
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value->branch_id] = $value->branch_name;
        }
        return $options ;
    }


    public function supervisorList(){
        $results = DB::table('employee')->where('status',1)->get();
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value->employee_id] = $value->first_name.' '.$value->last_name;
        }
        return $options ;
    }


    public function holidayList(){
        $results = DB::table('holiday')->get();
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value->holiday_id] = $value->holiday_name;
        }
        return $options ;
    }


    public function weekList(){
        $results = ['Saturday','Sunday','Monday','Tuesday','Wednesday','Thursday','Friday'];
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value] = $value;
        }
        return $options ;
    }


    public function leaveTypeList(){
        $results = DB::table('leave_type')->get();
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value->leave_type_id] = $value->leave_type_name;
        }
        return $options ;
    }


    public function workShiftList(){
        $results = WorkShift::get();
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value->work_shift_id] = $value->work_shift_name;
        }
        return $options ;
    }


    public function performanceCategoryList(){
        $results = PerformanceCategory::all();
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value->performance_category_id] = $value->performance_category_name;
        }
        return $options ;
    }


    public function trainingTypeList(){
        $results = TrainingType::where('status',1)->get();
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value->training_type_id] = $value->training_type_name;
        }
        return $options ;
    }

    public function payGradeList(){
        $results = PayGrade::all();
        $options = [''=>'---- Please select ----'];
        foreach ($results as $key => $value) {
            $options [$value->pay_grade_id] = $value->pay_grade_name;
        }
        return $options ;
    }

}
