<!DOCTYPE html>
	<html lang="en">
	<head>
		<title>My Attendance</title>
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
			<p style="margin-left: 42px;margin-top: 10px"><b>My Attendance Report</b></p>
		</div>
		<div class="container">
			<b>Name : </b>{{$employee_name}},<b>Department : </b>{{$department_name}}<b>,Form Date : </b>{{$form_date}} , <b>To Date : </b>{{$to_date}}
			<table id="" class="table table-bordered">
				<thead class="tr_header">
				<tr>
					<th >S/L</th>
					<th>Date</th>
					<th>In Time</th>
					<th>Out Time</th>
					<th>Working Time</th>
					<th>Late</th>
					<th>Late Time</th>
					<th>Over Time</th>
					<th>Status</th>
				</tr>
				</thead>
				<tbody>
				<?php
				$totalPresent = 0;
				$totalAbsence = 0;
				$totalLeave   = 0;
				$totalLate    = 0;
				?>

				{{$serial = null}}
				@if(count($results) > 0)
					@foreach($results AS $value)

						<tr>
							<td style="width:100px;">{{++$serial}}</td>
							<td>{{ $value['date'] }}</td>
							<td>
								<?php
								if ($value['in_time'] != '') {
									echo $value['in_time'];
								} else {
									echo "--";
								}
								?>
							</td>
							<td>
								<?php
								if ($value['out_time'] != '') {
									echo $value['out_time'];
								} else {
									echo "--";
								}
								?>
							</td>

							<td>
								<?php
								if( $value['working_time'] ==''){
									echo "--";
								}else{
									if ($value['working_time'] != '00:00:00' ) {
										echo date('H:i', strtotime($value['working_time']));
									} else {
										echo 'One Time Punch';
									}
								}

								?>
							</td>
							<td>
								<?php
								if($value['ifLate'] == ''){
									echo "--";
								}else{
									if($value['ifLate'] == 'Yes'){
										echo "<b style='color: red'>".$value['ifLate']."</b>";
										$totalLate +=1;
									}else{
										echo "No";
									}
								}

								?>
							</td>
							<td>
								<?php
								if($value['totalLateTime'] ==''){
									echo "--";
								}else{
									if ($value['totalLateTime'] != '00:00:00') {
										echo date('H:i', strtotime($value['totalLateTime']));
									}else{
										echo "--";
									}
								}
								?>

							</td>
							<td>
								<?php
								if($value['workingHour'] == '')	{
									echo "--";
								}else{
									$workingHour = new DateTime($value['workingHour']);
									$workingTime = new DateTime($value['working_time']);
									if($workingHour < $workingTime){
										$interval = $workingHour->diff($workingTime);
										echo $interval->format('%H:%I');
									}else{
										echo "--";
									}
								}
								?>
							</td>
							<td>
								<?php
								if($value['action'] =='Absence'){
									echo "<span style='color: #f33155'>Absence</span>";
									$totalAbsence +=1;
								}elseif($value['action'] =='Leave'){
									 echo "<span  style='color: #41b3f9'>Leave</span></p>";
									$totalLeave +=1;
								}else{
									echo "<span  style='color: #5cb85c'>Present</span>";
									$totalPresent +=1;
								}
								?>
							</td>
						</tr>
					@endforeach
				@else
					<tr>
						<td colspan="9"><strong>Data not available !</strong></td>
					</tr>
				@endif
				@if(count($results) > 0)
					<tr>
						<td colspan="7"></td>
						<td style="background: #eee"><b>Total Working days: &nbsp;</b></td>
						<td style="background: #eee"><b>{{$serial}}</b>  Days</td>
					</tr>
					<tr>
						<td colspan="7"></td>
						<td style="background: #fff"><b>Total Present: &nbsp;</b></td>
						<td style="background: #fff"><b>{{$totalPresent}}</b> Days</td>
					</tr>
					<tr>
						<td colspan="7"></td>
						<td style="background: #eee"><b>Total Absence: &nbsp;</b></td>
						<td style="background: #eee"><b>{{$totalAbsence}}</b> Days</td>
					</tr>
					<tr>
						<td colspan="7"></td>
						<td style="background: #fff"><b>Total Leave: &nbsp;</b></td>
						<td style="background: #fff"><b>{{$totalLeave}}</b> Days</td>
					</tr>
					<tr>
						<td colspan="7"></td>
						<td style="background: #eee"><b>Total Late: &nbsp;</b></td>
						<td style="background: #eee"><b>{{$totalLate}}</b> Days</td>
					</tr>
				@endif
				</tbody>
			</table>
		</div>
	</body>
</html>
