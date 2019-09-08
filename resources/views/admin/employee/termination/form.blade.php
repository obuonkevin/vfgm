@extends('admin.master')
@section('content')
@if(isset($editModeData))
	@section('title','Edit Termination')
@else
	@section('title','Add  New Termination')
@endif

	<div class="container-fluid">
		<div class="row bg-title">
			<div class="col-lg-5 col-md-5 col-sm-5 col-xs-12">
				<ol class="breadcrumb">
					<li class="active breadcrumbColor"><a href="{{ url('dashboard') }}"><i class="fa fa-home"></i> Dashboard</a></li>
					<li>@yield('title')</li>
				  
				</ol>
			</div>
			<div class="col-lg-7 col-md-7 col-sm-7 col-xs-12">
				<a href="{{route('termination.index')}}"  class="btn btn-success pull-right m-l-20 hidden-xs hidden-sm waves-effect waves-light"><i class="fa fa-list-ul" aria-hidden="true"></i>  View Termination</a>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="panel panel-info">
					<div class="panel-heading"><i class="mdi mdi-clipboard-text fa-fw"></i>@yield('title')</div>
					<div class="panel-wrapper collapse in" aria-expanded="true">
						<div class="panel-body">
							@if(isset($editModeData))
								{{ Form::model($editModeData, array('route' => array('termination.update', $editModeData->termination_id), 'method' => 'PUT','files' => 'true','class' => 'form-horizontal')) }}
							@else
								{{ Form::open(array('route' => 'termination.store','enctype'=>'multipart/form-data','class'=>'form-horizontal')) }}
							@endif
							<div class="form-body">
								<div class="row">
									<div class="col-md-offset-2 col-md-6">
										@if($errors->any())
											<div class="alert alert-danger alert-dismissible" role="alert">
												<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">×</span></button>
												@foreach($errors->all() as $error)
													<strong>{!! $error !!}</strong><br>
												@endforeach
											</div>
										@endif
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
									</div>
								</div>

								<div class="row">
									<div class="col-md-8">
										<div class="form-group">
											<label class="control-label col-md-4">Employee Terminated<span class="validateRq">*</span></label>
											<div class="col-md-8">
												{{ Form::select('terminate_to',$employeeList, Input::old('terminate_to'), array('class' => 'form-control terminate_to select2 required')) }}
											</div>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-md-8">
										<div class="form-group">
											<label class="control-label col-md-4">Termination Type<span class="validateRq">*</span></label>
											<div class="col-md-8">
												{!! Form::text('termination_type',Input::old('termination_type'), $attributes = array('class'=>'form-control required termination_type','id'=>'terminate_type','placeholder'=>'Enter termination type')) !!}
											</div>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-md-8">
										<div class="form-group">
											<label class="control-label col-md-4">Subject<span class="validateRq">*</span></label>
											<div class="col-md-8">
												{!! Form::text('subject',Input::old('subject'), $attributes = array('class'=>'form-control required subject','id'=>'subject','placeholder'=>'Enter subject')) !!}
											</div>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-md-8">
										<div class="form-group">
											<label class="control-label col-md-4">Terminated By<span class="validateRq">*</span></label>
											<div class="col-md-8">
												{{ Form::select('terminate_by',$employeeList, isset($editModeData) ? Input::old('terminate_by') : session('logged_session_data.employee_id'), array('class' => 'form-control terminate_by select2 required')) }}
											</div>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-md-8">
										<div class="form-group">
											<label class="control-label col-md-4">Notice Date<span class="validateRq">*</span></label>
											<div class="col-md-8">
												<div class="input-group">
													<div class="input-group-addon"><i class="fa fa-calendar"></i></div>
												{!! Form::text('notice_date',isset($editModeData) ? dateConvertDBtoForm($editModeData->notice_date) : Input::old('notice_date'), $attributes = array('class'=>'form-control required dateField','id'=>'notice_date','placeholder'=>'Enter notice date','readonly'=>'readonly')) !!}
												</div>
											</div>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-md-8">
										<div class="form-group">
											<label class="control-label col-md-4">Termination Date<span class="validateRq">*</span></label>
											<div class="col-md-8">
												<div class="input-group">
													<div class="input-group-addon"><i class="fa fa-calendar"></i></div>
												{!! Form::text('termination_date',isset($editModeData) ? dateConvertDBtoForm($editModeData->termination_date) : Input::old('termination_date'), $attributes = array('class'=>'form-control required dateField','id'=>'termination_date','placeholder'=>'Enter termination date','readonly'=>'readonly')) !!}
												</div>
											</div>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-md-8">
										<div class="form-group">
											<label class="control-label col-md-4">Description</label>
											<div class="col-md-8">
												{!! Form::textarea('description',Input::old('description'), $attributes = array('class'=>'form-control description','id'=>'warning_date','placeholder'=>'Enter description')) !!}
											</div>
										</div>
									</div>
								</div>

								<div class="form-actions">
									<div class="row">
										<div class="col-md-8">
											<div class="row">
												<div class="col-md-offset-4 col-md-8">
													@if(isset($editModeData))
														@if($editModeData->status == 1)
															<input name="update" type="submit" class="btn btn-info btn_style" value="Update">
															<input name="submit" type="submit" class="btn btn-info btn_style" value="Submit">
														@endif
													@else
														<button type="submit" class="btn btn-info btn_style"><i class="fa fa-check"></i> Save</button>
													@endif
												</div>
											</div>
										</div>
									</div>
								</div>

							</div>
							{{ Form::close() }}
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
@endsection
@section('page_scripts')
	<link rel="stylesheet" href="{!! asset('admin_assets/plugins/bower_components/html5-editor/bootstrap-wysihtml5.css')!!}" />
	<script src="{!! asset('admin_assets/js/cbpFWTabs.js')!!}"></script>
	<script src="{!! asset('admin_assets/plugins/bower_components/html5-editor/wysihtml5-0.3.0.js')!!}"></script>
	<script src="{!! asset('admin_assets/plugins/bower_components/html5-editor/bootstrap-wysihtml5.js')!!}"></script>

	<script type="text/javascript">
        (function() {
            $('.description').wysihtml5();

            [].slice.call(document.querySelectorAll('.sttabs')).forEach(function(el) {
                new CBPFWTabs(el);
            });
        })();
	</script>
@endsection



