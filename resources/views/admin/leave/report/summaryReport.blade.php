@extends('admin.master')
@section('content')
@section('title','Leave Summary Report')
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

</style>
<script>
    jQuery(function (){
        $("#leaveReport").validate();
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
								{{ Form::open(array('route' => 'summaryReport.summaryReport','id'=>'leaveReport')) }}
								<div class="col-md-1"></div>
								<div class="col-md-3">
									<div class="form-group employeeName">
										<label class="control-label" for="email">Employee<span class="validateRq">*</span></label>
										<select class="form-control employee_id select2 required" required name="employee_id">
											<option value="">---- Please select ----</option>
											@foreach($employeeList as $value)
												<option value="{{$value->employee_id}}" @if($value->employee_id == $employee_id) {{"selected"}} @endif>{{$value->first_name}} {{$value->last_name}}</option>
											@endforeach
										</select>
									</div>
								</div>
								<div class="col-md-3">
									<label class="control-label" for="email">From Date<span class="validateRq">*</span></label>
									<div class="input-group">
										<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
										<input type="text" class="form-control dateField required" readonly placeholder="Select Date"  name="from_date" value="@if(isset($from_date)) {{$from_date}}@else {{ dateConvertDBtoForm(date('Y-01-01')) }} @endif">
									</div>
								</div>

								<div class="col-md-3">
									<label class="control-label" for="email">To Date<span class="validateRq">*</span></label>
									<div class="input-group">
										<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
										<input type="text" class="form-control dateField required" readonly placeholder="Select Date"  name="to_date" value="@if(isset($to_date)) {{$to_date}}@else {{ dateConvertDBtoForm(date('Y-m-d')) }} @endif">
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
						@if(count($results) > 0)
							<h4 class="text-right">
								<a class="btn btn-success" style="color: #fff" href="{{ URL('downloadSummaryReport/?employee_id='.$employee_id.'&from_date='.$from_date.'&to_date='.$to_date)}}"><i class="fa fa-download fa-lg" aria-hidden="true"></i> Download PDF</a>
							</h4>
						@endif
                        @if(!empty($results))
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
                        @endif
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
@endsection
