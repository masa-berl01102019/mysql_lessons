<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class PostRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */

    // 認証のルールを書く際にauthorize()を使用する
    public function authorize()
    {
        // return false;
        return true; // 認証のルールがないので何でも通すという意味のtrueにしておく
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */

    // validationのルールを書く際にrules()を使用する
    public function rules()
    {
        return [
          'title'=>'required|min:3',
          'body'=>'required'
        ];
    }
    // validationのエラーメッセージをカスタマイズする際には下記のようにmessages()を作成して使用すればいい
    public function messages(){
      // 'title.required'に関するメッセージは'please enter title !!'となっている
      return[
        'title.required'=>'please enter title !!'
      ];
    }
}
