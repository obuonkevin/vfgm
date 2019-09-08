
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
		<p style="margin-left: 42px;margin-top: 10px"><b>Daily Attendance Report</b></p>
	</div>
	<div class="container">
		<b>Date : </b>{{$date}}
		<table class="table">
			<thead>
				<tr>
					<th >S/L</th>
					<th>Employee Name</th>
					<th>In Time</th>
					<th>Out Time</th>
					<th>Working Time</th>
					<th>Late</th>
					<th>Late Time</th>
					<th>Over Time</th>
				</tr>
			</thead>
			<tbody>
			@if(count($results) > 0)
				@foreach($results AS $key=>$data)
					<tr>
						<td colspan="8"><strong>{{$key}}</strong></td>
					</tr>
					@foreach($data as $key1=>$value)
						<tr>
							<td>{{++$key1}}</td>
							<td>{{$value->fullName}}</td>
							<td>{{$value->in_time}}</td>
							<td>
                                <?php
                                if ($value->out_time != '') {
                                    echo $value->out_time;
                                } else {
                                    echo "--";
                                }
                                ?>
							</td>

							<td>
                                <?php
                                if ($value->working_time != '00:00:00') {
                                    echo date('H:i', strtotime($value->working_time));
                                } else {
                                    echo 'One Time Punch';
                                }
                                ?>
							</td>
							<td>
                                <?php
                                if($value->ifLate == "Yes"){
                                    echo "<b style='color: red'>".$value->ifLate."</b>";
                                }else{
                                    echo "No";
                                }
                                ?>

							</td>
							<td>
                                <?php

                                if (date('H:i', strtotime($value->totalLateTime)) != '00:00') {
                                    echo date('H:i', strtotime($value->totalLateTime));
                                }else{
                                    echo "--";
                                }
                                ?>

							</td>
							<td>
                                <?php
                                $workingHour = new DateTime($value->workingHour);
                                $workingTime = new DateTime($value->working_time);
                                if($workingHour < $workingTime){
                                    $interval = $workingHour->diff($workingTime);
                                    echo $interval->format('%H:%I');
                                }else{
                                    echo "00:00";
                                }
                                ?>
							</td>
						</tr>
					@endforeach
				@endforeach
			@else
				<tr>
					<td colspan="8"><strong>No data have found !</strong></td>
				</tr>
			@endif
			</tbody>
		</table>
	</div>

</body>
</html>


