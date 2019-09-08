<div class="table-responsive">
	<table class="table table-bordered">
		<thead>
			 <tr class="tr_header">
				<th>S/L</th>
				<th>Month</th>
				<th>Photo</th>
				<th>Employee Name</th>
				<th>Pay Grade</th>
				<th>Basic Salary</th>
				<th>Gross Salary</th>
				<th>Status</th>
				<th>Action</th>
			</tr>
		</thead>
		<tbody>
			@if(count($results)>0)
				{!! $sl=null !!}
				@foreach($results AS $value)
					<tr>
						<td style="width: 100px;">{!! ++$sl !!}</td>
						<td>
							@php
								$monthAndYear   = explode('-',$value->month_of_salary);

								$month = $monthAndYear[1];
								$dateObj   = DateTime::createFromFormat('!m', $month);
								$monthName = $dateObj->format('F');
								$year = $monthAndYear[0];

								$monthAndYearName = $monthName." ".$year ;
								echo $monthAndYearName;
						   @endphp
						</td>
						<td>
							@if($value->employee->photo != '')
								<img style=" width: 70px; " src="{!! asset('uploads/employeePhoto/'.$value->employee->photo) !!}" alt="user-img" class="img-circle">
							@else
								<img style=" width: 70px; " src="{!! asset('admin_assets/img/default.png') !!}" alt="user-img" class="img-circle">
							@endif
						</td>
						<td>@if(isset($value->employee->first_name))
								{!!  $value->employee->first_name !!} {{$value->employee->last_name}}
							@endif
							@if(isset($value->employee->department->department_name))
							<br>
								<span class="text-muted">Department : {{$value->employee->department->department_name}}</span>
							@endif	
							
						</td>
						<td>
							@if(isset($value->employee->payGrade->pay_grade_name))
								{!!  $value->employee->payGrade->pay_grade_name !!}(Monthly)
							@endif
								@if(isset($value->employee->hourlySalaries->hourly_grade))
								{!!  $value->employee->hourlySalaries->hourly_grade !!}(Hourly)
							@endif
						</td>
						<td>{!! $value->basic_salary !!}</td>
						<td>{!! $value->gross_salary !!}</td>
						@if($value->status == 0)
							<td>
								<span class="label label-warning">Unpaid</span>
							</td>
						@else
							<td>
								<span class="label label-success">Paid</span>
							</td>
						@endif

						<td style="width: 100px">
							@if($value->status == 0)
							<button class="btn btn-info waves-effect waves-light"
									data-salary_details_id="{!! $value->salary_details_id !!}"
									data-monthAndYearName="{!! $monthAndYearName !!}"
									data-basic_salary="{!! $value->basic_salary !!}"
									data-gross_salary="{!! $value->gross_salary !!}"
									data-total_allowance="{!! $value->total_allowance !!}"
									data-total_deduction="{!! $value->total_deduction !!}"
									data-employee_name="@if(isset($value->employee->first_name)){!!  $value->employee->first_name !!} {{$value->employee->last_name}}@endif"
									data-toggle="modal" data-target="#responsive-modal"><span>Make Payment</span> </button>
							@else
								<a href="{{url('generateSalarySheet/generatePayslip',$value->salary_details_id)}}" target="_blank"><button  class="btn btn-success  waves-effect waves-light"><span>Generate Payslip</span> </button></a>
							@endif
						</td>

					</tr>
				@endforeach
			@else
				<tr>
					<td colspan="10">No data found !</td>
				</tr>
			@endif
		</tbody>
	</table>
	@if(count($results)>0)
		<div class="text-center">
			{{$results->links()}}
		</div>
	@endif
</div>