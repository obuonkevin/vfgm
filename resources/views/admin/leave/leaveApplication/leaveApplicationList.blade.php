@extends('admin.master')
@section('content')
@section('title','Requested Application')
  
	<div class="container-fluid">
		<div class="row bg-title">
			<div class="col-lg-7 col-md-7 col-sm-7 col-xs-12">
			   <ol class="breadcrumb">
					<li class="active breadcrumbColor"><a href="#"><i class="fa fa-home"></i> Dashboard</a></li>
					<li>@yield('title')</li>
				</ol>
			</div>	
		</div>
					
		<div class="row">
			<div class="col-sm-12">
				<div class="panel panel-info">
					<div class="panel-heading"><i class="mdi mdi-table fa-fw"></i> @yield('title')</div>
					<div class="panel-wrapper collapse in" aria-expanded="true">
						<div class="panel-body">
							@if(session()->has('success'))
                                <div class="alert alert-success alert-dismissable">
                                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                                    <i class="cr-icon glyphicon glyphicon-ok"></i>&nbsp;<strong>{{ session()->get('success') }}</strong>
                                </div>
                            @endif
                            @if(session()->has('error'))
                                <div class="alert alert-danger alert-dismissable">
                                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                                    <i class="glyphicon glyphicon-remove"></i>&nbsp;<strong>{{ session()->get('error') }}</strong>
                                </div>
                            @endif
                         <div class="table-responsive">
                            <table id="example1" class="table table-bordered table-hover ">
                                <thead class="tr_header">
                                     <tr>
                                        <th>S/L</th>
                                        <th>Employee Name</th>
                                        <th>Leave Type</th>
                                        <th>Request Duration</th>
                                        <th>Application Date</th>
                                        <th>Number Of Day</th>
                                        <th style="width: 300px;word-wrap: break-word;">Purpose</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                @if(count($results) > 0)
                                    {!! $sl = null !!}
                                        @foreach($results AS $value)
                                            <tr>
                                                <td style="width: 100px;">{!! ++$sl !!}</td>
                                                <td>
                                                    @if(isset($value->employee->first_name)) {!! $value->employee->first_name !!} @endif
                                                    @if(isset($value->employee->last_name)) {!! $value->employee->last_name !!} @endif
                                                </td>
                                                <td>@if(isset($value->leaveType->leave_type_name)) {!! $value->leaveType->leave_type_name !!} @endif</td>
                                                <td>{!! dateConvertDBtoForm($value->application_from_date) !!} <b>to</b> {!! dateConvertDBtoForm($value->application_to_date) !!}</td>
                                                <td>{!! dateConvertDBtoForm($value->application_date) !!}</td>
                                                <td>{!! $value->number_of_day !!}</td>
                                                <td>{!! $value->purpose !!}</td>
                                                @if($value->status == 1)
                                                    <td  style="width: 100px;">
                                                        <span class="label label-warning">Pending</span>
                                                    </td>
                                                @elseif($value->status == 2)
                                                    <td  style="width: 100px;">
                                                        <span class="label label-success">Approved</span>
                                                    </td>
                                                @else
                                                    <td  style="width: 100px;">
                                                        <span class="label label-danger">Rejected</span>
                                                    </td>
                                                @endif

                                                <td>
                                                    @if($value->status == 1)
                                                        <a href="{!! route('requestedApplication.viewDetails',$value->leave_application_id ) !!}" title="View leave details!" class="btn btn-info btn-md btnColor">
                                                            <i class="fa fa-arrow-circle-right"></i>
                                                        </a>
                                                    @endif
                                                </td>
                                            </tr>
                                        @endforeach
                                 @else
                                    <tr>
                                        <td colspan="9">You have no Leave application !</td>
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