@extends('admin.master')
@section('content')
@if(isset($editModeData))
@section('formtitle','Edit Category')
@else
@section('formtitle','Add Category')
@endif

<div class="post d-flex flex-column-fluid" id="kt_post">
    <!--begin::Container-->
    <div id="kt_content_container" class="container">
        <!--begin::Card-->
        <div class="card">
                <!--begin::Card body-->
            <div class="card-body p-0">
                <!--begin::Wrapper-->
                <div class="card-px text-center py-20 my-10">
                    <!--begin::Title-->
                    <h2 class="fs-2x fw-bolder mb-10">Welcome!</h2>
                    <!--end::Title-->
                    <!--begin::Description-->
                    <p class="text-gray-400 fs-4 fw-bold mb-10">Edit Category Information here</p>
                    <!--end::Description-->
                    <!--begin::Action-->
                    <a href="#" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#kt_modal_add_user">Edit User</a>
                    <!--end::Action-->
                </div>
                <!--end::Wrapper-->
                <!--begin::Illustration-->
                <div class="text-center px-4">
                    <img class="mw-100 mh-300px" alt="" src="assets/media/illustrations/work.png" />
                </div>
                <!--end::Illustration-->
            </div>
            <!--end::Card body-->

        </div>
        <!--end::Card-->
    </div>
    <!--end::Container-->
</div>
<!--end::Post-->
    <!--begin::Modal - Add task-->
	<div class="modal fade" id="kt_modal_add_user" tabindex="-1" aria-hidden="true">
		<!--begin::Modal dialog-->
		<div class="modal-dialog modal-dialog-centered mw-650px">
			<!--begin::Modal content-->
			<div class="modal-content">
				<!--begin::Modal header-->
				<div class="modal-header" id="kt_modal_add_user_header">
					<!--begin::Modal title-->
					<h2 class="fw-bolder">@yield('formtitle')</h2>
					<!--end::Modal title-->
					<!--begin::Close-->
					<div class="btn btn-icon btn-sm btn-active-icon-primary" data-kt-users-modal-action="close">
						<!--begin::Svg Icon | path: icons/duotone/Navigation/Close.svg-->
						<span class="svg-icon svg-icon-1">
							<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24px" height="24px" viewBox="0 0 24 24" version="1.1">
								<g transform="translate(12.000000, 12.000000) rotate(-45.000000) translate(-12.000000, -12.000000) translate(4.000000, 4.000000)" fill="#000000">
									<rect fill="#000000" x="0" y="7" width="16" height="2" rx="1" />
									<rect fill="#000000" opacity="0.5" transform="translate(8.000000, 8.000000) rotate(-270.000000) translate(-8.000000, -8.000000)" x="0" y="7" width="16" height="2" rx="1" />
								</g>
							</svg>
						</span>
						<!--end::Svg Icon-->
					</div>
					<!--end::Close-->
				</div>
				<!--end::Modal header-->
				<!--begin::Modal body-->
				<div class="modal-body scroll-y mx-5 mx-xl-15 my-7">
					<!--begin::Form-->
					<form action="{{ route('category.update') }}" method="POST" enctype="multipart/form-data">
				{{-- {{ Form::model($editModeData, array('route' => array('category.update', $editModeData->category_id), 'method' => 'PUT','files' => 'true','class' => 'form','id'=>'kt_modal_add_user_form')) }} --}}

						<!--begin::Scroll-->
						<div class="d-flex flex-column scroll-y me-n7 pe-7" id="kt_modal_add_user_scroll" data-kt-scroll="true" data-kt-scroll-activate="{default: false, lg: true}" data-kt-scroll-max-height="auto" data-kt-scroll-dependencies="#kt_modal_add_user_header" data-kt-scroll-wrappers="#kt_modal_add_user_scroll" data-kt-scroll-offset="300px">

							<!--begin::Input group-->

							<div class="fv-row mb-7">
								<!--begin::Label-->
								<label class="required fw-bold fs-6 mb-2">Category Name</label>
								<!--end::Label-->
								<!--begin::Input-->
								<input type="text" name="category_name" placeholder="Enter category name" required="">
								{{-- {!! Form::text('category_name',Input::old('category_name'), $attributes
								= array('class'=>'form-control form-control-solid mb-3 mb-lg-0 required
								category_name','id'=>'category_name','placeholder'=>'Enter category name')) !!}
									<!--end::Input--> --}}
							</div>

							<div class="fv-row mb-7">
								<!--begin::Label-->
								<label class="required fw-bold fs-6 mb-2">Description</label>
								<input type="text" name="description" placeholder="Enter Description" required="">
								{{-- {!! Form::text('description',Input::old('description'), $attributes
									= array('class'=>'form-control form-control-solid mb-3 mb-lg-0
									description','id'=>'description','placeholder'=>'Enter category description')) !!}
								</div> --}}

						</div>
						<!--end::Scroll-->
						<!--begin::Actions-->
						<div class="text-center pt-15">
							<button type="reset" class="btn btn-white me-3" data-kt-users-modal-action="cancel">Discard</button>
							<button type="submit" class="btn btn-primary" data-kt-users-modal-action="submit">
								<span class="indicator-label">Submit</span>
								<span class="indicator-progress">Please wait...
								<span class="spinner-border spinner-border-sm align-middle ms-2"></span></span>
							</button>
						</div>
						<!--end::Actions-->
					{{-- {{ form::close() }} --}}
				</form>
					<!--end::Form-->
				</div>
				<!--end::Modal body-->
			</div>
			<!--end::Modal content-->
		</div>
		<!--end::Modal dialog-->
	</div>
	<!--end::Modal - Add task-->
@endsection