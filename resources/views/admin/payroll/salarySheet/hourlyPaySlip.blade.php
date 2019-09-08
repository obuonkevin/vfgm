@extends('admin.master')
@section('content')
@section('title','Employee Payslip')
<style>
	.table>tbody>tr>td {
		padding: 5px 7px;
	}
</style>
<div class="container-fluid">
	<div class="row bg-title">
		<div class="col-lg-5 col-md-5 col-sm-5 col-xs-12">
			<ol class="breadcrumb">
				<li class="active breadcrumbColor"><a href="{{ url('dashboard') }}"><i class="fa fa-home"></i> Dashboard</a></li>
				<li>@yield('title')</li>

			</ol>
		</div>

	</div>
	<div class="row">
		<div class="col-md-12">
			<div class="panel panel-info">
				<div  class="panel-heading"><i class="mdi mdi-clipboard-text fa-fw"></i> Employee Payslip</div>

				<div class="row">
					<div class="col-md-12">
						<h4 style="margin-left: 22px;">
							<a class="btn btn-success" style="color: #fff" href="{{ URL('downloadPayslip/'.$paySlipId)}}"><i class="fa fa-download fa-lg" aria-hidden="true"></i> Download PDF</a>
						</h4>
					</div>
				</div>

				<div class="panel-wrapper collapse in" aria-expanded="true">
					<div class="panel-body">
						<div class="form-body">

							<div class="col-md-12 text-center">

								<h3><strong>Salary sheet/ Final Balance </strong></h3>
							</div>
							<div class="row">
								<div class="col-md-offset-2 col-md-8">
									<table class="table table-bordered table-hover table-striped">
										<tbody>
										<tr>
											<td>Month :   </td>
											<td> <b>{{convartMonthAndYearToWord($salaryDetails->month_of_salary)}}</b></td>
										</tr>
										<tr>
											<td>Pay Grade :   </td>
											<td> <b>@if(isset($salaryDetails->employee->hourlySalaries->hourly_grade))
														{{$salaryDetails->employee->hourlySalaries->hourly_grade}} (Hourly)
													@endif</b></td>
										</tr>
										<tr>
											<td class="col-md-6">Name :</td>
											<td class="col-md-6"><b>
													@if(isset($salaryDetails->employee->first_name))
														{{$salaryDetails->employee->first_name}} {{$salaryDetails->employee->last_name}}
													@endif</b>
											</td>
										</tr>
										<tr>
											<td>Department :</td>
											<td><b>@if(isset($salaryDetails->employee->department->department_name))
														{{$salaryDetails->employee->department->department_name}}
													@endif</b></td>
										</tr>
										<tr>
											<td>Designation :</td>
											<td><b>@if(isset($salaryDetails->employee->designation->designation_name))
														{{$salaryDetails->employee->designation->designation_name}}
													@endif</b></td>
										</tr>
										<tr>
											<td>Joining Date : </td>
											<td><b>@if(isset($salaryDetails->employee->date_of_joining))
														{{date(" d-M-Y", strtotime($salaryDetails->employee->date_of_joining))}}
													@endif
													</b></td>
										</tr>

										<tr>
											<td>Working Hour</td>
											<td class="text-center">
												{{$salaryDetails->working_hour}}
											</td>
										</tr>
										<tr>
											<td>Hourly Rate</td>
											<td class="text-center">
												{{number_format($salaryDetails->hourly_rate)}}
												<input type="hidden" readonly  class="form-control" value="{{$salaryDetails->hourly_rate}}" name="hourly_rate">
											</td>
										</tr>
										<tr>
											<td >Total Salary</td>
											<td class="text-center">
												{{number_format($salaryDetails->gross_salary)}}
											</td>
										</tr>

										<tr>
											<td colspan="1" ><b>Gross Salary</b></td>
											<td class="text-center">
												<b>{{number_format($salaryDetails->gross_salary)}}</b>
											</td>
										</tr>

										</tbody>
									</table>
									<div class="col-sm-12 col-xs-12 col-md-4">
										<strong>Administrator signature ....</strong>
									</div>
									<div class="col-sm-12 col-xs-12 col-md-4">
										<strong>Date ....</strong>

									</div>
									<div class="col-sm-12 col-xs-12 col-md-4">
										<strong>Employee signature ....
										</strong>
									</div>
								</div>



							</div>
							<br>


						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
@endsection

