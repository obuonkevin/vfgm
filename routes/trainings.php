<?php

Route::group(['middleware' => ['preventbackbutton','auth']], function(){

    Route::group(['prefix' => 'training'], function () {
        Route::get('/',['as' => 'training.index', 'uses'=>'Training\TrainingsController@index']);
        Route::get('/create',['as' => 'training.create', 'uses'=>'Training\TrainingsController@create']);
        Route::post('/store',['as' => 'training.store', 'uses'=>'Training\TrainingsController@store']);
        Route::get('/{training}/edit',['as'=>'training.edit','uses'=>'Training\TrainingsController@edit']);
        Route::put('/{training}',['as' => 'training.update', 'uses'=>'Training\TrainingsController@update']);
        Route::get('/{training}/delete',['as'=>'training.delete','uses'=>'Training\TrainingsController@destroy']);
    });

});

