<div class="table-responsive">
    <table  class="table table-hover manage-u-table">
        <thead>
			<tr>
				<th>#</th>
				<th>Photo</th>
				<th>Name</th>
				<th>Department</th>
				<th>Phone</th>
				<th>Fingerprint No.</th>
				<th>Pay Grade</th>
				<th>Joining Date</th>
                <th>Status</th>
                <th>Action</th>
			</tr>
        </thead>
        <tbody>
        {!! $sl=null !!}
        @foreach($results AS $value)
            <tr class="{!! $value->employee_id !!}">
                <td style="width: 100px;">{!! ++$sl !!}</td>
                <td>
                    @if($value->photo != '' && file_exists('uploads/employeePhoto/'.$value->photo))
                        <img style=" width: 70px; " src="{!! asset('uploads/employeePhoto/'.$value->photo) !!}" alt="user-img" class="img-circle">
                    @else
                        <img style=" width: 70px; " src="{!! asset('admin_assets/img/default.png') !!}" alt="user-img" class="img-circle">
                    @endif
                </td>
                <td>
					<span class="font-medium">
						{!! $value->first_name !!}&nbsp;{!! $value->last_name !!}
					</span>
						<br/><span class="text-muted">Role :
						@if(isset($value->userName->role->role_name)) {!! $value->userName->role->role_name !!} @endif
					</span>
					<br/><span class="text-muted">
						@if (isset($value->supervisor->first_name)) Supervisor :  {!! $value->supervisor->first_name !!} {!! $value->supervisor->last_name !!}@endif
					</span>
                </td>
                <td>
					<span class="font-medium">
						@if (isset($value->department->department_name)) {!! $value->department->department_name !!} @endif
					</span>
                    <br/><span class="text-muted">Designation :
                        @if (isset($value->designation->designation_name)) {!! $value->designation->designation_name!!} @endif
					</span>
                    <br/><span class="text-muted">
						@if (isset($value->branch->branch_name))  Branch :  {!! $value->branch->branch_name!!} @endif
						</span>

                </td>
                <td>
					<span class="font-medium">
						+880{{	$value->phone}}
					</span>
                    <br/><span class="text-muted">
						@if($value->email!='')Email :{!! $value->email !!}@endif
					</span>
                </td>
                <td>
                    <span class="font-medium">
                        {!! $value->finger_id !!}</td>
					</span>
                <td>
                    <span class="font-medium">
                         @if (isset($value->payGrade->pay_grade_name)) {!! $value->payGrade->pay_grade_name!!} <span class="bdColor">(Monthly)</span> @endif
                        @if (isset($value->hourlySalaries->hourly_grade)) {!! $value->hourlySalaries->hourly_grade!!} <span class="bdColor">(Hourly)</span>@endif
                     </span>
                </td>
                <td>
                    <span class="font-medium">
						{{dateConvertDBtoForm($value->date_of_joining)}}
					</span>
                    <br/><span class="text-muted">
                        {{ \Carbon\Carbon::parse($value->date_of_joining)->diffForHumans() }}
					</span>
                </td>
                <td>
                    <select class="form-control permanent_status">
                        <option value="0">Probation Period</option>
                        <option value="1">Permanent</option>
                    </select>
                </td>
                <input type="hidden" class="employee_id" value="{{$value->employee_id}}">
                <td style="width: 150px">
                    <button type="button" class="btn btn-sm btn-success updateStatus">
                        Update Status
                    </button>
                </td>
            </tr>
        @endforeach
        </tbody>
    </table>
    <div class="text-center">
        {{$results->links()}}
    </div>
</div>