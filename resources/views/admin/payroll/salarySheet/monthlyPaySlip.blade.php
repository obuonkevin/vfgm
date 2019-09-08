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
				<div class="col-md-12 text-right">
					<h4 style="">
						<a class="btn btn-success" style="color: #fff" href="{{ URL('downloadPayslip/'.$paySlipId)}}"><i class="fa fa-download fa-lg" aria-hidden="true"></i> Download PDF</a>
					</h4>
				</div>

				<div class="row" style="margin-top: 25px">

					<div class="col-md-12 text-center">

						<h3><strong>Salary sheet/ Final Balance </strong></h3>
					</div>
				</div>

				<div class="panel-wrapper collapse in" aria-expanded="true">
					<div class="panel-body" style="    padding: 18px 49px;">
						<div class="row" style="border: 1px solid #ddd;padding: 26px 9px">
							<div class="col-md-6">
								<table class="table table-bordered table-hover table-striped">
									<tbody>
									<tr>
										<td>Name :</td>
										<td ><b>{{$salaryDetails->first_name}} {{$salaryDetails->last_name}}</b></td>
									</tr>
									<tr>
										<td>Department :</td>
										<td><b>{{$salaryDetails->department_name}}</b></td>
									</tr>
									<tr>
										<td>Designation :</td>
										<td><b>{{$salaryDetails->designation_name}}</b></td>
									</tr>
									<tr>
										<td>Joining Date : </td>
										<td><b>{{date(" d-M-Y", strtotime($salaryDetails->date_of_joining))}} </b></td>
									</tr>
									<tr>
										<td>Basic salary of the month : </td>
										<td class="text-center">{{number_format($salaryDetails->basic_salary)}}</td>
									</tr>
									@if(count($salaryDetailsToAllowance) > 0)
										@foreach($salaryDetailsToAllowance as $allowance)
											<tr>
												<td>{{$allowance->allowance_name}}: </td>
												<td class="text-center"> {{number_format($allowance->amount_of_allowance)}}</td>
											</tr>
										@endforeach
									@endif
									<tr>
										<td>Net salary : </td>
										<td class="text-center" style="background: #ddd"> {{number_format($salaryDetails->net_salary)}}</td>
									</tr>
									<tr>
										<td>Taxable salary :  </td>
										<td class="text-center"> {{number_format($salaryDetails->taxable_salary)}}</td>
									</tr>
									<tr>
										<td>Income tax to pay for the month :  </td>
										<td class="text-center"> {{number_format($salaryDetails->tax)}}</td>
									</tr>
									@php
										$companyTaxDeduction = 0;
										$companyTaxDeduction = ($salaryDetails->tax * 70) / 100;

										$employeeTaxDeduction = 0;
										$employeeTaxDeduction = ($salaryDetails->tax * 30) / 100;
									@endphp
									<tr>
										<td>Company tax deduction :  </td>
										<td class="text-center"> {{number_format(round($companyTaxDeduction))}}</td>
									</tr>
									<tr>
										<td>Employee tax payable:  </td>
										<td class="text-center"> {{number_format(round($employeeTaxDeduction))}}</td>
									</tr>
									@if(count($salaryDetailsToDeduction) > 0)
										@foreach($salaryDetailsToDeduction as $deduction)
											<tr>
												<td>{{$deduction->deduction_name}} :  </td>
												<td class="text-center"> {{number_format($deduction->amount_of_deduction)}}</td>
											</tr>
										@endforeach
									@endif
									@if($salaryDetails->total_late_amount !=0)
										<tr>
											<td>Late Amount :  </td>
											<td class="text-center"> {{number_format($salaryDetails->total_late_amount)}}</td>
										</tr>
									@endif
									@if($salaryDetails->total_absence_amount !=0)
										<tr>
											<td>Absence Amount :  </td>
											<td class="text-center"> {{number_format($salaryDetails->total_absence_amount)}}</td>
										</tr>
									@endif
									@if($salaryDetails->total_overtime_amount != 0)
										<tr>
											<td>Over Time : </td>
											<td class="text-center"> {{number_format($salaryDetails->total_overtime_amount)}}</td>
										</tr>
									@endif
									<tr>
										<td> Net salary to be paid :  </td>
										<td class="text-center" style="background: #ddd">  {{number_format($salaryDetails->gross_salary)}}   </td>
									</tr>
									<tr>
										<td>  Total income tax deducted for the financial year :  </td>
										<td class="text-center" >    {{number_format($financialYearTax->totalTax)}}  </td>
									</tr>
									</tbody>
								</table>
							</div>
							<div class="col-md-6">
								<table class="table table-bordered table-hover table-striped">
									<tbody>
									<tr>
										<td class="col-md-6">No. :  </td>
										<td class="col-md-6"> <b>1</b></td>
									</tr>
									<tr>
										<td>Month :   </td>
										<td> <b>{{convartMonthAndYearToWord($salaryDetails->month_of_salary)}}</b></td>
									</tr>
									<tr>
										<td>Date : </td>
										<td><b>{{date(" d-M-Y", strtotime(date('Y-m-d')))}} </b></td>
									</tr>
									<tr>
										<td>Number of working days :  </td>
										<td> <b>{{$salaryDetails->total_working_days}}</b></td>
									</tr>
									<tr>
										<td>  Number of day worked in the month  :  </td>
										<td class="text-center">   {{$salaryDetails->total_present}}   </td>
									</tr>

									<tr>
										<td> Unjustified  absence  :  </td>
										<td class="text-center">   {{$salaryDetails->total_absence}}   </td>
									</tr>
									<tr>
										<td>  Per day salary  :  </td>
										<td class="text-center">   {{number_format($salaryDetails->per_day_salary)}}   </td>
									</tr>
									@if($salaryDetails->total_late !=0)
										<tr>
											<td>  Salary deduction for late attendance  :  </td>
											<td class="text-center">   {{$salaryDetails->total_late}}   </td>
										</tr>
									@endif
									@if($salaryDetails->total_overtime_amount !=0)
										<tr>
											<td>  Over Time  :  </td>
											<td class="text-center">   {{$salaryDetails->total_over_time_hour}}   </td>
										</tr>
										<tr>
											<td>  Over Rate  :  </td>
											<td class="text-center">   {{$salaryDetails->overtime_rate}}  </td>
										</tr>
									@endif
									@if(count($salaryDetailsToLeave) > 0)
										@foreach($salaryDetailsToLeave as $leaveRecord)
											<tr>
												<td>  {{$leaveRecord->leave_type_name}} :  </td>
												<td class="text-center">   {{$leaveRecord->num_of_day}}   </td>
											</tr>
										@endforeach
									@endif
									</tbody>
								</table>
							</div>
							<div class="row">
								<div class="col-md-6"></div>
								<div class="col-md-6"></div>
							</div>
							<div class="col-md-4">
								<p style="font-weight: 500;">Administrator signature ....</p>
							</div>
							<div class="col-md-4 text-center">
								<p style="font-weight: 500;"> Date .... </p>
							</div>
							<div class="col-md-4 text-right">
								<p style="font-weight: 500;"> Employee signature .... </p>
							</div>
						</div>


					</div>
				</div>
			</div>
		</div>
	</div>
</div>
@endsection

