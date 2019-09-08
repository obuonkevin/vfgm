@extends('admin.master')
@section('content')
@if(isset($editModeData))
	@section('title','Edit Training Type ')
@else
	@section('title','Add Training Type')
@endif
	<div class="container-fluid">
		<div class="row bg-title">
			<div class="col-lg-3 col-md-4 col-sm-4 col-xs-12">
				<ol class="breadcrumb">
					<li class="active breadcrumbColor"><a href="{{ url('dashboard') }}"><i class="fa fa-home"></i> Dashboard</a></li>
					<li>@yield('title')</li>
				</ol>
			</div>
			<div class="col-lg-9 col-md-8 col-sm-8 col-xs-12">
				<a href="{{route('trainingType.index')}}"  class="btn btn-success pull-right m-l-20 hidden-xs hidden-sm waves-effect waves-light"><i class="fa fa-list-ul" aria-hidden="true"></i>  View Training Type
				</a>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="panel panel-info">
					<div class="panel-heading"><i class="mdi mdi-clipboard-text fa-fw"></i>@yield('title')</div>
					<div class="panel-wrapper collapse in" aria-expanded="true">
						<div class="panel-body">
							@if(isset($editModeData))
								{{ Form::model($editModeData, array('route' => array('trainingType.update', $editModeData->training_type_id), 'method' => 'PUT','files' => 'true','class' => 'form-horizontal','id'=>'trainingTypeForm')) }}
							@else
								{{ Form::open(array('route' => 'trainingType.store','enctype'=>'multipart/form-data','class'=>'form-horizontal','id'=>'trainingTypeForm')) }}
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
												<label class="control-label col-md-4">Training Type Name<span class="validateRq">*</span></label>
												<div class="col-md-8">
													{!! Form::text('training_type_name',Input::old('training_type_name'), $attributes = array('class'=>'form-control required training_type_name','id'=>'training_type_name','placeholder'=>'Enter training type')) !!}
												</div>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-md-8">
											<div class="form-group">
												<label class="control-label col-md-4">Status<span class="validateRq">*</span></label>
												<div class="col-md-8">
													{{ Form::select('status', array('1' => 'Active', '2' => 'Inactive'), Input::old('status'), array('class' => 'form-control status select2 required')) }}
												</div>
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
														<button type="submit" class="btn btn-info btn_style"><i class="fa fa-pencil"></i> Update</button>
													@else
														<button type="submit" class="btn btn-info btn_style"><i class="fa fa-check"></i> Save</button>
													@endif
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

