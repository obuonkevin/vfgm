@extends('admin.master')
@section('content')
@section('title','Dashboard')
<style>
    @if(count($attendanceData) > 3)
	tbody {
        display:block;
        height:300px;
        overflow:auto;
    }
    thead, tbody tr {
        display:table;
        width:100%;
        table-layout:fixed;
    }
    thead {
        width: calc( 100% - 1em )
    }
    @endif
    @if(count($leaveApplication) >= 1)
        .leaveApplication{
            overflow-x: hidden;
            height: 210px;
        }
    @endif
    @if(count($notice) >= 1)
        .noticeBord{
            overflow-x: hidden;
            height: 210px;
        }
    @endif
</style>

<div class="container-fluid">
    <div class="row bg-title">
        <div class="col-lg-3 col-md-4 col-sm-4 col-xs-12">
            <ol class="breadcrumb">
                <li class="active breadcrumbColor"><a href="#"><i class="fa fa-home"></i> Dashboard</a></li>
            </ol>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-3 col-sm-6 col-xs-12">
            <div class="white-box analytics-info">
                <h3 class="box-title">Total EMPLOYEE</h3>
                <ul class="list-inline two-part">
                    <li>
                        <div id="sparklinedash"></div>
                    </li>
                    <li class="text-right"><i class="ti-arrow-up text-success"></i> <span class="counter text-success">{{$totalEmployee}}</span></li>
                </ul>
            </div>
        </div>

        <div class="col-lg-3 col-sm-6 col-xs-12">
            <div class="white-box analytics-info">
                <h3 class="box-title">DEPARTMENT</h3>
                <ul class="list-inline two-part">
                    <li>
                        <div id="sparklinedash2"></div>
                    </li>
                    <li class="text-right"><i class="ti-arrow-up text-purple"></i> <span class="counter text-purple">{{$totalDepartment}}</span></li>
                </ul>
            </div>
        </div>

        <div class="col-lg-3 col-sm-6 col-xs-12">
            <div class="white-box analytics-info">
                <h3 class="box-title">PRESENT</h3>
                <ul class="list-inline two-part">
                    <li>
                        <div id="sparklinedash3"></div>
                    </li>
                    <li class="text-right"><i class="ti-arrow-up text-info"></i> <span class="counter text-info">{{$totalAttendance}}</span></li>
                </ul>
            </div>
        </div>

        <div class="col-lg-3 col-sm-6 col-xs-12">
            <div class="white-box analytics-info">
                <h3 class="box-title">ABSENT </h3>
                <ul class="list-inline two-part">
                    <li>
                        <div id="sparklinedash4"></div>
                    </li>
                    <li class="text-right"><i class="ti-arrow-down text-danger"></i> <span class="counter text-danger">{{$totalAbsent}}</span></li>
                </ul>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12 col-lg-12 col-sm-12">
            <div class="panel">
                <div class="panel-heading"> TODAY ATTENDANCE </div>
                <div class="table-responsive">
                    <table class="table table-hover manage-u-table">
                        <thead>
                        <tr>
                            <th  class="text-center">#</th>
                            <th>PHOTO</th>
                            <th>NAME</th>
                            <th>IN TIME</th>
                            <th>OUT TIME</th>
                            <th>LATE</th>
                        </tr>
                        </thead>
                        <tbody>
                        @if(count($attendanceData) > 0)
                            {{$dailyAttendanceSl =null }}
                            @foreach($attendanceData as  $dailyAttendance)
                            <tr>
                                <td class="text-center">{{ ++$dailyAttendanceSl }}</td>
                                <td>
                                    @if($dailyAttendance->photo != '')
                                        <img style=" width: 70px; " src="{!! asset('uploads/employeePhoto/'.$dailyAttendance->photo) !!}" alt="user-img" class="img-circle">
                                    @else
                                        <img style=" width: 70px; " src="{!! asset('admin_assets/img/default.png') !!}" alt="user-img" class="img-circle">
                                    @endif
                                </td>
                                <td>{{$dailyAttendance->fullName}}
                                    <br/><span class="text-muted">{{$dailyAttendance->department_name}}</span>
                                </td>
                                <td>{{$dailyAttendance->in_time}} </td>
                                <td>
                                    <?php
                                        if($dailyAttendance->out_time !=''){
                                            echo $dailyAttendance->out_time;
                                        }else{
                                            echo "--";
                                        }
                                    ?>
                                </td>

                                <td>
                                    <?php
                                        if (date('H:i', strtotime($dailyAttendance->totalLateTime)) != '00:00') {
                                            echo "<b style='color: red;'>".date('H:i', strtotime($dailyAttendance->totalLateTime))."</b>";
                                        }else{
                                            echo "<b style='color: green'><i class='cr-icon glyphicon glyphicon-ok'></i></b>";
                                        }
                                    ?>

                                </td>

                            </tr>
                            @endforeach
                            @else
                            <tr>
                                <td colspan="8">No data available </td>
                            </tr>
                        @endif
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        @if(count($leaveApplication) > 0)
            <div class="col-md-12 col-lg-6 col-sm-12">
                <div class="white-box">
                    <h3 class="box-title">Recent Leave Application</h3>
                    <hr>
                    <div class="leaveApplication">
                    @foreach($leaveApplication as $leaveApplication)
                    <div class="comment-center p-t-10 {{$leaveApplication->leave_application_id}}">
                        <div class="comment-body">
                            @if($leaveApplication->employee->photo !='')
                                <div class="user-img"> <img src="{!! asset('uploads/employeePhoto/'.$leaveApplication->employee->photo) !!}" alt="user" class="img-circle"></div>
                            @else
                                <div class="user-img"> <img src="{!! asset('admin_assets/img/default.png') !!}" alt="user" class="img-circle"></div>
                            @endif
                            <div class="mail-contnet" >
                                @php
                                    $d=strtotime($leaveApplication->created_at);
                                @endphp
                                <h5>{{$leaveApplication->employee->first_name}} {{$leaveApplication->employee->last_name}}</h5><span class="time">{{date(" d M Y h:i: a", $d)}}</span> <span class="label label-rouded label-info">PENDING</span>
                                <br/><span class="mail-desc" style="max-height: none">
                                    Leave Type: {{$leaveApplication->leaveType->leave_type_name}}<br>
                                    Request Duration: {{dateConvertDBtoForm($leaveApplication->application_from_date)}} To {{dateConvertDBtoForm($leaveApplication->application_to_date)}}<br>
                                    Number Of Day: {{$leaveApplication->number_of_day}} <br>
                                    Purpose: {{$leaveApplication->purpose}}
                                </span>

                                <a href="javacript:void(0)" data-status=2 data-leave_application_id="{{$leaveApplication->leave_application_id}}" class="btn remarksForLeave btn btn-rounded btn-success btn-outline m-r-5"><i class="ti-check text-success m-r-5"></i>Approve</a>
                                <a href="javacript:void(0)"  data-status=3 data-leave_application_id="{{$leaveApplication->leave_application_id}}" class="btn-rounded remarksForLeave btn btn-danger btn-outline"><i class="ti-close text-danger m-r-5"></i> Reject</a> </div>
                        </div>
                    </div>
                    @endforeach
                    </div>
                </div>
            </div>
        @endif
         @if(count($notice) > 0)
        <div class="col-md-12 col-lg-6 col-sm-12">
            <div class="white-box">
                <h3 class="box-title">Notice Board</h3>
                <hr>
                <div class="noticeBord">
                    @foreach($notice as $row)
                        @php
                            $noticeDate=strtotime($row->publish_date);
                        @endphp
                    <div class="comment-center p-t-10">
                        <div class="comment-body">

                            <div class="user-img"><i style="font-size: 31px" class="fa fa-flag-checkered text-danger"></i></div>

                            <div class="user-img"> <i style="font-size: 31px" class="icon-folder-alt text-info"></i></div>

                            <div class="mail-contnet">
                                <h5 class="text-danger">{{ substr($row->title,0,70)}}..</h5><span class="time">Published Date: {{date(" d M Y ", $noticeDate)}}</span>
                                <br/><span class="mail-desc">
                                    Published By: {{$row->createdBy->first_name}} {{$row->createdBy->last_name}}<br>
                                    Description: {!!  substr($row->description,0,80)!!}..
                                </span>
                                <a href="{{url('notice/'.$row->notice_id)}}" class="btn m-r-5 btn-rounded btn-outline btn-info">Read More</a> </div>
                        </div>
                    </div>
                   @endforeach
                </div>
            </div>
        </div>
        @endif
    </div>
</div>

@endsection


@section('page_scripts')
<link href="{!! asset('admin_assets/plugins/bower_components/news-Ticker-Plugin/css/site.css') !!}" rel="stylesheet" type="text/css" />
<script src="{!! asset('admin_assets/plugins/bower_components/news-Ticker-Plugin/scripts/jquery.bootstrap.newsbox.min.js') !!}"></script>

    <script type="text/javascript">
        (function() {

            $(".demo1").bootstrapNews({
                newsPerPage: 2,
                autoplay: true,
                pauseOnHover:true,
                direction: 'up',
                newsTickerInterval: 4000,
                onToDo: function () {
                    //console.log(this);
                }
            });

        })();

        $(document).on('click', '.remarksForLeave', function () {

            var actionTo = "{{ URL::to('approveOrRejectLeaveApplication') }}";
            var leave_application_id = $(this).attr('data-leave_application_id');
            var status = $(this).attr('data-status');

            if(status == 2){
                var statusText = "Are you want to approve leave application?";
                var btnColor = "#2cabe3";
            }else{
                var statusText = "Are you want to reject leave application?";
                var btnColor = "red";
            }

            swal({
                    title: "",
                    text: statusText,
                    type: "warning",
                    showCancelButton: true,
                    confirmButtonColor: btnColor,
                    confirmButtonText: "Yes",
                    closeOnConfirm: false
                },
                function (isConfirm) {
                    var token = '{{ csrf_token() }}';
                    if (isConfirm) {
                        $.ajax({
                            type: 'POST',
                            url:actionTo,
                            data: {leave_application_id:leave_application_id,status:status,_token:token},
                            success: function (data) {
                                if (data == 'approve') {
                                    swal({
                                            title: "Approved!",
                                            text: "Leave application approved.",
                                            type: "success"
                                        },
                                        function (isConfirm) {
                                            if (isConfirm) {
                                                $('.' + leave_application_id).fadeOut();
                                            }
                                        });

                                }else{
                                    swal({
                                            title: "Rejected!",
                                            text: "Leave application rejected.",
                                            type: "success"
                                        },
                                        function (isConfirm) {
                                            if (isConfirm) {
                                                $('.' + leave_application_id).fadeOut();
                                            }
                                        });
                                }
                            }

                        });
                    } else {
                        swal("Cancelled", "Your data is safe .", "error");
                    }
                });
            return false;

        });
    </script>
@endsection