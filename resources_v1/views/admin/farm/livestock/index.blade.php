@extends('admin.master')
@section('content')
@section('title','Livestock List')
<div class="container-fluid">
	<div class="row">
		<div class="col-sm-12">
			<div class="panel panel-info">
				<div class="panel-heading">
					<div class="row">
						<div class="col-lg-3 col-md-4 col-sm-4 col-xs-12">
							<i class="mdi mdi-table fa-fw"></i> @yield('title')
						</div>
						<div class="col-lg-9 col-sm-8 col-md-8 col-xs-12">
							<a href="{{ route('livestock.create') }}"
								class="btn btn-success pull-right m-l-20 hidden-xs hidden-sm waves-effect waves-light">
								<i class="fa fa-plus-circle" aria-hidden="true"></i> Add Livestock</a>
						</div>
					</div>
				</div>
				<div class="panel-wrapper collapse in" aria-expanded="true">
					<div class="panel-body">
						@if(session()->has('success'))
						<div class="alert alert-success alert-dismissable">
							<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
							<i
								class="cr-icon glyphicon glyphicon-ok"></i>&nbsp;<strong>{{ session()->get('success') }}</strong>
						</div>
						@endif
						@if(session()->has('error'))
						<div class="alert alert-danger alert-dismissable">
							<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
							<i
								class="glyphicon glyphicon-remove"></i>&nbsp;<strong>{{ session()->get('error') }}</strong>
						</div>
						@endif
						<div class="table-responsive">
							<table id="myTable" class="table table-bordered">
								<thead>
									<tr class="tr_header">
										<th>S/L</th>
										<th>Farmer</th>
										<th>Phone No</th>
										<th>Animal</th>
										<th>Number</th>
										<th>Gender</th>
										<th>Age</th>
										<th style="text-align: center;">Action</th>
									</tr>
								</thead>
								<tbody>
									{!! $sl=null !!}
									@foreach($results AS $value)
									<tr class="{!! $value->livestock_id !!}">
										<td style="width: 50px;">{!! ++$sl !!}</td>
										<td>{!! $value->user->first_name.' '.$value->user->last_name !!}</td>
										<td>{!! $value->user->phone_no !!}</td>
										<td>{!! $value->livestock_name !!}</td>
										<td>{!! $value->number !!}</td>
										<td>{!! $value->gender !!}</td>
										<td>{!! $value->age !!}</td>
										<td style="width: 100px;">
											<a href="{!! route('livestock.edit',$value->livestock_id) !!}"
												class="btn btn-success btn-xs btnColor">
												<i class="fa fa-pencil-square-o" aria-hidden="true"></i>
											</a>
											<a href="{!!route('livestock.delete',$value->livestock_id )!!}"
												data-token="{!! csrf_token() !!}" data-id="{!! $value->livestock_id!!}"
												class="delete btn btn-danger btn-xs deleteBtn btnColor"><i
													class="fa fa-trash-o" aria-hidden="true"></i></a>
										</td>
									</tr>
									@endforeach
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