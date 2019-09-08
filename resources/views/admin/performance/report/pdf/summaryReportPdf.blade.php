
<!DOCTYPE html>
	<html lang="en">
	<head>
		<title>Daily Attendance</title>
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
		@if($printHead)
			{!! $printHead->description !!}
		@endif
		<br>
		<br>
	</div>
	<div class="container">
		<div class="table-responsive">
			<b>From Month : </b>{{$from_month}},
			<b>To Month : </b>{{$to_month}}
			<table id="" class="table table-bordered">
				<thead class="tr_header">
				<tr>
					<th style="width:100px;">S/L</th>
					<th>Month</th>
					<th style="width: 500px">Rating(Out of 10)</th>
				</tr>
				</thead>
				<tbody>
					@if(count($results) > 0)
						@php
							$serial = 0;
							$totalRating = 0;
							$item = 0;
						@endphp
						@foreach($results AS $value)
							@php
								$item++;
								$totalRating += round($value->avgRating,2);
							@endphp
							<tr>
								<td style="width:100px;">{{++$serial}}</td>
								<td>{{convartMonthAndYearToWord($value->month) }}</td>
								<td>{{round($value->avgRating,2)}}</td>
							</tr>
						@endforeach
						<tr>
							<td colspan="1"></td>
							<td class="text-right"><b>Employee Name: &nbsp;</b></td>
							<td ><b></b> {{$value->first_name }} {{$value->last_name }} ({{$value->department_name}})</td>
						</tr>
						<tr>
							<td colspan="1"></td>
							<td class="text-right"><b>Total Rating: &nbsp;</b></td>
							<td ><b></b> {{ $totalRating }} </td>
						</tr>
						<tr>
							<td colspan="1"></td>
							<td class="text-right"><b>Average Rating: &nbsp;</b></td>
							<td ><b></b> {{ $totalRating / $item }} </td>
						</tr>
					@else
						<tr>
							<td colspan="3">Data not available !</td>
						</tr>
					@endif
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>


