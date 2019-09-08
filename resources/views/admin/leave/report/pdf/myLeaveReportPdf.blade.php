
<!DOCTYPE html>
	<html lang="en">
	<head>
		<title>My Leave Report</title>
		<meta charset="utf-8">
	</head>
	<style>
		table {
			margin: 0 0 40px 0;
			width: 100%;
			box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
			display: table;
			border-collapse: collapse;
		}
		.printHead{
			width: 35%;
			margin: 0 auto;
		}
		table, td, th {
			border: 1px solid black;
		}
		td{
			padding: 5px;
		}

		th{
			padding: 5px;
		}

	</style>
	<body>
	<div class="printHead">
		@if(count($printHead) > 0)
			{!! $printHead->description !!}
		@endif
		<br>
		<br>
	</div>
	<div class="container">
		<b>Name : </b>{{$employee_name}},<b>Department : </b>{{$department_name}}<b>,Form Date : </b>{{$form_date}} , <b>To Date : </b>{{$to_date}}
		<div class="table-responsive">
			<table id="" class="table table-bordered">
				<thead class="tr_header">
				<tr>
					<th style="width:100px;">S/L</th>
					<th>Leave Type</th>
					<th>Applied Date</th>
					<th>Request Duration</th>
					<th>Approve BY</th>
					<th>Approve Date</th>
					<th>Purpose</th>
					<th>Number of Day</th>

				</tr>
				</thead>
				<tbody>
					@if(count($results) > 0)
						{{$sl=null}}
						@foreach($results as $value)
						<tr>
							<td>{{++$sl}}</td>
							<td>@if($value->leaveType->leave_type_name) {{$value->leaveType->leave_type_name}} @endif</td>
							<td>{{dateConvertDBtoForm($value->application_date)}}</td>
							<td>{{dateConvertDBtoForm($value->application_from_date)}} <b>to</b> {{dateConvertDBtoForm($value->application_to_date)}}</td>
							<td>@if($value->approveBy->first_name) {{$value->approveBy->first_name}} {{$value->approveBy->last_name}} @endif</td>
							<td>{{dateConvertDBtoForm($value->approve_date)}}</td>
							<td width="300px;word-wrap: break-word">{{$value->purpose}}</td>
							<td>{{$value->number_of_day}}</td>
						</tr>
						@endforeach
					@else
						<tr>
							<td colspan="8">No data have found !</td>
						</tr>
					@endif
				</tbody>
			</table>
        </div>
	</div>

</body>
</html>


