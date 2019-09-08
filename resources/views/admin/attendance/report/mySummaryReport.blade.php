@extends('admin.master')
@section('content')
@section('title','My Attendance Report')
<style>
	.employeeName{
		position: relative;
	}
	#employee_id-error{
		position: absolute;
		top: 66px;
		left: 0;
		width: 100%he;
		width: 100%;
		height: 100%;
	}
		/*
		tbody {
			display:block;
			height:500px;
			overflow:auto;
		}
		thead, tbody tr {
			display:table;
			width:100%;
			table-layout:fixed;
		}
		thead {
			width: calc( 100% - 1em )
		}*/


</style>
<script>
    jQuery(function (){
        $("#monthlyAttendance").validate();
     });

</script>
<div class="container-fluid">
	<div class="row bg-title">
		<div class="col-lg-7 col-md-7 col-sm-7 col-xs-12">
			<ol class="breadcrumb">
				<li class="active breadcrumbColor"><a href="{{ url('dashboard') }}"><i class="fa fa-home"></i> Dashboard</a></li>
				<li>@yield('title')</li>
			</ol>
		</div>

	</div>

	<div class="row">
		<div class="col-sm-12">
			<div class="panel panel-info">
				<div class="panel-heading"><i class="mdi mdi-table fa-fw"></i>@yield('title')</div>
				<div class="panel-wrapper collapse in" aria-expanded="true">
					<div class="panel-body">
						<div class="row">
							<div id="searchBox">
								{{ Form::open(array('route' => 'myAttendanceReport.myAttendanceReport','id'=>'monthlyAttendance')) }}
								<div class="col-md-1"></div>
								<div class="col-md-3">
									<div class="form-group employeeName">
										<label class="control-label" for="email">Employee<span class="validateRq">*</span></label>
										<select  class="form-control employee_id select2 required" required name="employee_id">
											@foreach($employeeList as $value)
												<option value="{{$value->employee_id}}" >{{$value->first_name}} {{$value->last_name}}</option>
											@endforeach
										</select>
									</div>
								</div>
								<div class="col-md-3">
									<label class="control-label" for="email">From Date<span class="validateRq">*</span></label>
									<div class="input-group">
										<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
										<input type="text" class="form-control dateField required" readonly placeholder="Select Date"  name="from_date" value="@if(isset($from_date)) {{$from_date}}@else {{ dateConvertDBtoForm(date('Y-m-01')) }} @endif">
									</div>
								</div>

								<div class="col-md-3">
									<label class="control-label" for="email">To Date<span class="validateRq">*</span></label>
									<div class="input-group">
										<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
										<input type="text" class="form-control dateField required" readonly placeholder="Select Date"  name="to_date" value="@if(isset($to_date)) {{$to_date}}@else {{ dateConvertDBtoForm( date("Y-m-t", strtotime(date('Y-m-01')))) }} @endif">
									</div>
								</div>
								<div class="col-md-2">
									<div class="form-group">
										<input type="submit" id="filter" style="margin-top: 25px; width: 100px;" class="btn btn-info " value="Filter">
									</div>
								</div>
								{{ Form::close() }}
							</div>
							</div>
						<hr>
						<h4 class="text-right">
							@if(isset($from_date))
								@if(count($results) > 0)
									<a class="btn btn-success" style="color: #fff" href="{{ URL('downloadMyAttendance/?employee_id='.$employee_id.'&from_date='.$from_date.'&to_date='.$to_date)}}"><i class="fa fa-download fa-lg" aria-hidden="true"></i> Download PDF</a>
								@endif
							@else
								@if(count($results) > 0)
									<a class="btn btn-success" style="color: #fff" href="{{ URL('downloadMyAttendance/?employee_id='.session('logged_session_data.employee_id').'&from_date='.dateConvertDBtoForm(date('Y-m-01')).'&to_date='.dateConvertDBtoForm( date("Y-m-t", strtotime(date('Y-m-01')))))}}"><i class="fa fa-download fa-lg" aria-hidden="true"></i> Download PDF</a>
								@endif
							@endif
						</h4>
						<div class="table-responsive">
							<table id="" class="table table-bordered">
								<thead class="tr_header">
								<tr>
									<th style="width:100px;">S/L</th>
									<th>Date</th>
									<th>Employee Name</th>
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
											<td>{{$value['fullName']}}</td>
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
                                                    echo "<span class='label label-danger'>Absence</span>";
                                                    $totalAbsence +=1;
                                                }elseif($value['action'] =='Leave'){
                                                    echo "<span class='label label-info'>Leave</span></p>";
                                                    $totalLeave +=1;
                                                }else{
                                                    echo "<span class='label label-success'>Present</span>";
                                                    $totalPresent +=1;
                                                }
                                                ?>
											</td>
										</tr>
									@endforeach
								@else
									<tr>
										<td colspan="10">Data not available !</td>
									</tr>
								@endif
								@if(count($results) > 0)
									<tr>
										<td colspan="8"></td>
										<td style="background: #eee"><b>Total Working days: &nbsp;</b></td>
										<td style="background: #eee"><b>{{$serial}}</b>  Days</td>
									</tr>
									<tr>
										<td colspan="8"></td>
										<td style="background: #fff"><b>Total Present: &nbsp;</b></td>
										<td style="background: #fff"><b>{{$totalPresent}}</b> Days</td>
									</tr>
									<tr>
										<td colspan="8"></td>
										<td style="background: #eee"><b>Total Absence: &nbsp;</b></td>
										<td style="background: #eee"><b>{{$totalAbsence}}</b> Days</td>
									</tr>
									<tr>
										<td colspan="8"></td>
										<td style="background: #fff"><b>Total Leave: &nbsp;</b></td>
										<td style="background: #fff"><b>{{$totalLeave}}</b> Days</td>
									</tr>
									<tr>
										<td colspan="8"></td>
										<td style="background: #eee"><b>Total Late: &nbsp;</b></td>
										<td style="background: #eee"><b>{{$totalLate}}</b> Days</td>
									</tr>
								@endif
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
@endsection
