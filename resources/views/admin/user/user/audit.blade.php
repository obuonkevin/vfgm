@extends('admin.master')
@section('content')
@section('title','Audit Trail')
@include('admin.partials.lower_top_menu_bar')
	<!--begin::Page-->


						<!--begin::Post-->
						<div class="post d-flex flex-column-fluid" id="kt_post">
							<!--begin::Container-->
							<div id="kt_content_container" class="container">
								<!--begin::Card-->
								<div class="card">
									<!--begin::Card header-->
									<div class="card-header border-0 pt-6">
										<!--begin::Card title-->
										<div class="card-title">
											<!--begin::Search-->
											<div class="d-flex align-items-center position-relative my-1">
												<!--begin::Svg Icon | path: icons/duotone/General/Search.svg-->
												<span class="svg-icon svg-icon-1 position-absolute ms-6">
													<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24px" height="24px" viewBox="0 0 24 24" version="1.1">
														<g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
															<rect x="0" y="0" width="24" height="24" />
															<path d="M14.2928932,16.7071068 C13.9023689,16.3165825 13.9023689,15.6834175 14.2928932,15.2928932 C14.6834175,14.9023689 15.3165825,14.9023689 15.7071068,15.2928932 L19.7071068,19.2928932 C20.0976311,19.6834175 20.0976311,20.3165825 19.7071068,20.7071068 C19.3165825,21.0976311 18.6834175,21.0976311 18.2928932,20.7071068 L14.2928932,16.7071068 Z" fill="#000000" fill-rule="nonzero" opacity="0.3" />
															<path d="M11,16 C13.7614237,16 16,13.7614237 16,11 C16,8.23857625 13.7614237,6 11,6 C8.23857625,6 6,8.23857625 6,11 C6,13.7614237 8.23857625,16 11,16 Z M11,18 C7.13400675,18 4,14.8659932 4,11 C4,7.13400675 7.13400675,4 11,4 C14.8659932,4 18,7.13400675 18,11 C18,14.8659932 14.8659932,18 11,18 Z" fill="#000000" fill-rule="nonzero" />
														</g>
													</svg>
												</span>
												<!--end::Svg Icon-->
												<input type="text" data-kt-user-table-filter="search" class="form-control form-control-solid w-250px ps-14" placeholder="Search audit" />
											</div>
											<!--end::Search-->
										</div>
										<!--begin::Card title-->
										<!--begin::Card toolbar-->
										<div class="card-toolbar">
											<!--begin::Toolbar-->
											<div class="d-flex justify-content-end" data-kt-user-table-toolbar="base">
												<!--begin::Filter-->
												<button type="button" class="btn btn-light-primary me-3" data-kt-menu-trigger="click" data-kt-menu-placement="bottom-end" data-kt-menu-flip="top-end">
												<!--begin::Svg Icon | path: icons/duotone/Text/Filter.svg-->
												<span class="svg-icon svg-icon-2">
													<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24px" height="24px" viewBox="0 0 24 24" version="1.1">
														<g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
															<rect x="0" y="0" width="24" height="24" />
															<path d="M5,4 L19,4 C19.2761424,4 19.5,4.22385763 19.5,4.5 C19.5,4.60818511 19.4649111,4.71345191 19.4,4.8 L14,12 L14,20.190983 C14,20.4671254 13.7761424,20.690983 13.5,20.690983 C13.4223775,20.690983 13.3458209,20.6729105 13.2763932,20.6381966 L10,19 L10,12 L4.6,4.8 C4.43431458,4.5790861 4.4790861,4.26568542 4.7,4.1 C4.78654809,4.03508894 4.89181489,4 5,4 Z" fill="#000000" />
														</g>
													</svg>
												</span>
												<!--end::Svg Icon-->Filter</button>
												<!--begin::Menu 1-->
												<div class="menu menu-sub menu-sub-dropdown w-300px w-md-325px" data-kt-menu="true">
													<!--begin::Header-->
													<div class="px-7 py-5">
														<div class="fs-5 text-dark fw-bolder">Filter Options</div>
													</div>
													<!--end::Header-->
													<!--begin::Separator-->
													<div class="separator border-gray-200"></div>
													<!--end::Separator-->
													<!--begin::Content-->
													<div class="px-7 py-5" data-kt-user-table-filter="form">
														<!--begin::Input group-->
														<div class="mb-10">
															<label class="form-label fs-6 fw-bold">Role:</label>
															<select class="form-select form-select-solid fw-bolder" data-kt-select2="true" data-placeholder="Select option" data-allow-clear="true" data-kt-user-table-filter="role" data-hide-search="true">
																<option></option>
																<option value="Administrator">Administrator</option>
																<option value="Analyst">Analyst</option>
																<option value="Developer">Developer</option>
																<option value="Support">Support</option>
																<option value="Trial">Trial</option>
															</select>
														</div>
														<!--end::Input group-->
														<!--begin::Input group-->
														<div class="mb-10">
															<label class="form-label fs-6 fw-bold">Two Step Verification:</label>
															<select class="form-select form-select-solid fw-bolder" data-kt-select2="true" data-placeholder="Select option" data-allow-clear="true" data-kt-user-table-filter="two-step" data-hide-search="true">
																<option></option>
																<option value="Enabled">Enabled</option>
															</select>
														</div>
														<!--end::Input group-->
														<!--begin::Actions-->
														<div class="d-flex justify-content-end">
															<button type="reset" class="btn btn-white btn-active-light-primary fw-bold me-2 px-6" data-kt-menu-dismiss="true" data-kt-user-table-filter="reset">Reset</button>
															<button type="submit" class="btn btn-primary fw-bold px-6" data-kt-menu-dismiss="true" data-kt-user-table-filter="filter">Apply</button>
														</div>
														<!--end::Actions-->
													</div>
													<!--end::Content-->
												</div>
												<!--end::Menu 1-->
												<!--end::Filter-->
												<!--begin::Export-->
												<button type="button" class="btn btn-light-primary me-3" data-bs-toggle="modal" data-bs-target="#kt_modal_export_users">
												<!--begin::Svg Icon | path: icons/duotone/Files/Export.svg-->
												<span class="svg-icon svg-icon-2">
													<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="24px" height="24px" viewBox="0 0 24 24" version="1.1">
														<g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
															<rect x="0" y="0" width="24" height="24" />
															<path d="M17,8 C16.4477153,8 16,7.55228475 16,7 C16,6.44771525 16.4477153,6 17,6 L18,6 C20.209139,6 22,7.790861 22,10 L22,18 C22,20.209139 20.209139,22 18,22 L6,22 C3.790861,22 2,20.209139 2,18 L2,9.99305689 C2,7.7839179 3.790861,5.99305689 6,5.99305689 L7.00000482,5.99305689 C7.55228957,5.99305689 8.00000482,6.44077214 8.00000482,6.99305689 C8.00000482,7.54534164 7.55228957,7.99305689 7.00000482,7.99305689 L6,7.99305689 C4.8954305,7.99305689 4,8.88848739 4,9.99305689 L4,18 C4,19.1045695 4.8954305,20 6,20 L18,20 C19.1045695,20 20,19.1045695 20,18 L20,10 C20,8.8954305 19.1045695,8 18,8 L17,8 Z" fill="#000000" fill-rule="nonzero" opacity="0.3" />
															<rect fill="#000000" opacity="0.3" transform="translate(12.000000, 8.000000) scale(1, -1) rotate(-180.000000) translate(-12.000000, -8.000000)" x="11" y="2" width="2" height="12" rx="1" />
															<path d="M12,2.58578644 L14.2928932,0.292893219 C14.6834175,-0.0976310729 15.3165825,-0.0976310729 15.7071068,0.292893219 C16.0976311,0.683417511 16.0976311,1.31658249 15.7071068,1.70710678 L12.7071068,4.70710678 C12.3165825,5.09763107 11.6834175,5.09763107 11.2928932,4.70710678 L8.29289322,1.70710678 C7.90236893,1.31658249 7.90236893,0.683417511 8.29289322,0.292893219 C8.68341751,-0.0976310729 9.31658249,-0.0976310729 9.70710678,0.292893219 L12,2.58578644 Z" fill="#000000" fill-rule="nonzero" transform="translate(12.000000, 2.500000) scale(1, -1) translate(-12.000000, -2.500000)" />
														</g>
													</svg>
												</span>
												<!--end::Svg Icon-->Export</button>
												<!--end::Export-->
											</div>
											<!--end::Toolbar-->
											<!--begin::Group actions-->
											<div class="d-flex justify-content-end align-items-center d-none" data-kt-user-table-toolbar="selected">
												<div class="fw-bolder me-5">
												<span class="me-2" data-kt-user-table-select="selected_count"></span>Selected</div>
												<button type="button" class="btn btn-danger" data-kt-user-table-select="delete_selected">Delete Selected</button>
											</div>
											<!--end::Group actions-->
											<!--begin::Modal - Adjust Balance-->
											<div class="modal fade" id="kt_modal_export_users" tabindex="-1" aria-hidden="true">
												<!--begin::Modal dialog-->
												<div class="modal-dialog modal-dialog-centered mw-650px">
													<!--begin::Modal content-->
													<div class="modal-content">
														<!--begin::Modal header-->
														<div class="modal-header">
															<!--begin::Modal title-->
															<h2 class="fw-bolder">Export Users</h2>
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
															<form id="kt_modal_export_users_form" class="form" action="#">
																<!--begin::Input group-->
																<div class="fv-row mb-10">
																	<!--begin::Label-->
																	<label class="fs-6 fw-bold form-label mb-2">Select Roles:</label>
																	<!--end::Label-->
																	<!--begin::Input-->
																	<select name="role" data-control="select2" data-placeholder="Select a role" data-hide-search="true" class="form-select form-select-solid fw-bolder">
																		<option></option>
																		<option value="Administrator">Administrator</option>
																		<option value="Analyst">Analyst</option>
																		<option value="Developer">Developer</option>
																		<option value="Support">Support</option>
																		<option value="Trial">Trial</option>
																	</select>
																	<!--end::Input-->
																</div>
																<!--end::Input group-->
																<!--begin::Input group-->
																<div class="fv-row mb-10">
																	<!--begin::Label-->
																	<label class="required fs-6 fw-bold form-label mb-2">Select Export Format:</label>
																	<!--end::Label-->
																	<!--begin::Input-->
																	<select name="format" data-control="select2" data-placeholder="Select a format" data-hide-search="true" class="form-select form-select-solid fw-bolder">
																		<option></option>
																		<option value="excel">Excel</option>
																		<option value="pdf">PDF</option>
																		<option value="cvs">CVS</option>
																		<option value="zip">ZIP</option>
																	</select>
																	<!--end::Input-->
																</div>
																<!--end::Input group-->
																<!--begin::Actions-->
																<div class="text-center">
																	<button type="reset" class="btn btn-white me-3" data-kt-users-modal-action="cancel">Discard</button>
																	<button type="submit" class="btn btn-primary" data-kt-users-modal-action="submit">
																		<span class="indicator-label">Submit</span>
																		<span class="indicator-progress">Please wait...
																		<span class="spinner-border spinner-border-sm align-middle ms-2"></span></span>
																	</button>
																</div>
																<!--end::Actions-->
															</form>
															<!--end::Form-->
														</div>
														<!--end::Modal body-->
													</div>
													<!--end::Modal content-->
												</div>
												<!--end::Modal dialog-->
											</div>
											<!--end::Modal - New Card-->
										</div>
										<!--end::Card toolbar-->
									</div>
									<!--end::Card header-->
									<!--begin::Card body-->
									<div class="card-body pt-0">
										<!--begin::Table-->
										<table class="table align-middle table-row-dashed fs-6 gy-5" id="kt_table_users">
											<!--begin::Table head-->
											<thead>
												<!--begin::Table row-->
												<tr class="text-start text-gray-400 fw-bolder fs-7 text-uppercase gs-0">
													<th class="w-10px pe-2">
														<div class="form-check form-check-sm form-check-custom form-check-solid me-3">
															<input class="form-check-input" type="checkbox" data-kt-check="true" data-kt-check-target="#kt_table_users .form-check-input" value="1" />
														</div>
													</th>
													<th class="min-w-125px">Name</th>
													<th class="min-w-125px">Action</th>
													<th class="min-w-125px">Date</th>
												</tr>
												<!--end::Table row-->
											</thead>
											<!--end::Table head-->
											<!--begin::Table body-->
											<tbody class="text-gray-600 fw-bold">
												<!--begin::Table row-->
                                                @foreach($data AS $value)
												<tr>
													<!--begin::Checkbox-->
													<td>
														<div class="form-check form-check-sm form-check-custom form-check-solid">
															<input class="form-check-input" type="checkbox" value="1" />
														</div>
													</td>
													<!--end::Checkbox-->
													<!--begin::User=-->
													<td class="d-flex align-items-center">

														<!--begin::User details-->
														<div class="d-flex flex-column">
															<a href="apps/user-management/users/view.html" class="text-gray-800 text-hover-primary mb-1">{!! $value->user_name !!}</a>
															<span>{!! $value->email !!}</span>
														</div>
														<!--begin::User details-->
													</td>
													<!--end::User=-->
													<!--begin::Role=-->
													<td>{!!  $value->action !!}</td>
													<!--end::Role=-->
													<!--begin::username=-->
													<td>
														<div class="badge badge-light fw-bolder">{!! $value->created_at !!}</div>
													</td>
													<!--end::username=-->
													<!--begin::status-->
												</tr>
												<!--end::Table row-->

                                                @endforeach
											</tbody>
											<!--end::Table body-->
										</table>
										<!--end::Table-->
									</div>
									<!--end::Card body-->
								</div>
								<!--end::Card-->
							</div>
							<!--end::Container-->
						</div>
						<!--end::Post-->


			<!--end::Page-->
@endsection
