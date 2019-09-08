<div class="table-responsive">
	<table  id="" class="table table-bordered">
		<thead>
		<tr class="tr_header">
			<th>S/L</th>

			<th>Employee Name</th>
			<th>Pay Grade</th>
			<th>Basic Salary</th>
			<th>Gross Salary</th>
			<th>To be paid</th>
		</tr>
		</thead>
		<tbody>

		@if(count($results) > 0)
			{!! $sl=null !!}
			@foreach($results AS $value)
				<tr>
					<td style="width: 100px;">{!! ++$sl !!}</td>

					<td>
						{!!  $value->fullName !!}
						<br>
						<span class="text-muted">Department : {{$value->department_name}}</span>
					</td>
					<td>
						@if($value->pay_grade_name !='')
							{{$value->pay_grade_name}} (Monthly)
						@else
							{{$value->hourly_grade}} (Hourly)
						@endif
					</td>
					<td>{!! $value->basic_salary !!}</td>
					<td>{!! $value->gross_salary !!}</td>
					<td>{!! $value->gross_salary !!}</td>

				</tr>
			@endforeach
		@else
			<tr>
				<td colspan="9">No data have found ! </td>
			</tr>
		@endif
		</tbody>
	</table>

</div>

