
<!DOCTYPE html>
	<html lang="en">
	<head>
		<title>Leave Summary Report</title>
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
						<th>Number Of Day</th>
						<th>Leave Consume</th>
						<th>Current Leave Balance</th>
					</tr>
                </thead>
				<tbody>
					@if(count($results) > 0)
						{{$sl=null}}
						@foreach($results as $value)
						<tr>
							<td>{{++$sl}}</td>
							<td>{{$value['leave_type_name']}}</td>
							<td>{{$value['num_of_day']}}</td>
							<td>{{$value['leave_consume']}}</td>
							<td>{{$value['current_balance']}}</td>
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


