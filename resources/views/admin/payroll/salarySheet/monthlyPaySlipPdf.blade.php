
<!DOCTYPE html>
	<html lang="en">
	<head>
		<title>PaySlip</title>
		<meta charset="utf-8">
	</head>
	<style>
		table {
			margin: 0 0 40px 0;
			width: 100%;
			box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
			display: table;
			border-spacing: 0px;
		}
		table, td, th {border: 1px solid #ddd;}
		td{padding: 3px;}
		th{padding: 3px;}
		.text-center{
			text-align: center;
		}
		.companyAddress{
			width: 367px;
			margin: 0 auto;
		}
		.container {
			padding-right: 15px;
			padding-left: 15px;
			margin-right: auto;
			margin-left: auto;
			width: 95%;
		}
		.row {
			margin-right: -15px;
			margin-left: -15px;
		}
		.col-md-6 {
			width: 49%;
			float: left;
			padding-right: .5%;
			padding-left: .5%;
		}
		.div1{
			position: relative;
		}
		.div2{
			position: absolute;
			width: 100%;
			border: 1px solid;
			padding: 30px 12px 0px 12px;
		}
		.col-md-4 {
			width: 33.33333333%;
			float: left;
		}
		.clearFix{
			clear:both;
		}
		.padding{
			margin-bottom: 32px;

		}
	</style>
	<body>
	<div class="container">
		<div class="row">
			<div class=" companyAddress">
				<div class="headingStyle" style="margin-left: 30px;">
					@if($printHeadSetting){!! $printHeadSetting->description !!}@endif
				</div>
				<h3 style="    margin-left: 65px;"><strong>Salary sheet/ Final Balance</strong></h3>
			</div>
			<div class="div1">
				<div class="div2">
					<div class="clearFix">
						<div class="col-md-6">
							<table >
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
							<table class="table">
								<tbody>
								<tr>
									<td >No. :  </td>
									<td > <b>1</b></td>
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
										<td> Over Time  :  </td>
										<td class="text-center">   {{$salaryDetails->total_over_time_hour}}   </td>
									</tr>
									<tr>
										<td> Over Rate  :  </td>
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
					</div>
					<div class="clearFix padding">
						<div class="col-md-4" style="text-align: center;">
							<strong>Administrator signature ...</strong>
						</div>
						<div class=" col-md-4" style="text-align: center;">
							<strong>Date  ...</strong>
						</div>
						<div class=" col-md-4" style="text-align: center;">
							<strong>Employee signature ...</strong>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

</body>
</html>


