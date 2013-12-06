require 'spec_helper'

describe PadsController do
  fixtures :pads

  describe 'GET new' do
    it 'はkeyがcreateの仮の@padを生成する (200)' do
      get :new
      actual = assigns(:pad)
      expect(actual.key).to eq 'create'
      expect(actual.content).to eq PadsController::DEFAULT_CONTENT
      expect(response.status).to eq 200
      expect(response).to render_template :show
    end
  end

  describe 'POST create' do
    it 'は渡されたcontentの内容で@padを生成する (201)' do
      post :create, { content: 'Hello!' }
      actual = assigns(:pad)
      expect(actual.content).to eq 'Hello!'
      expect(response.status).to eq 201
      expect(response).to render_template :show
    end

    it 'は不正な値が渡された場合、ステータス400を返す (400)' do
      post :create, { content: nil }
      expected = { errors: ['本文は1文字以上で入力してください。'] }
      actual = JSON(response.body).symbolize_keys
      expect(response.status).to eq 400
      expect(actual).to eq expected
    end
  end

  describe 'GET show' do
    it 'はkeyのみ渡された場合、該当する@padを返す (200)' do
      get :show, { key: 'test-pad1' }
      actual = assigns(:pad)
      expect(response.status).to eq 200
      expect(actual.id).to eq 4
    end

    it 'はkeyとrevisionが渡された場合、該当する@padを返す (200)' do
      get :show, { key: 'test-pad1', revison: '2013-0101-0000' }
      actual = assigns(:pad)
      expect(actual.id).to eq 1
      expect(response.status).to eq 200
    end

    it 'はkeyが存在しない場合、ステータス404を返す (404)' do
      get :show, { key: 'notf-ound' }
      expected = { errors: ['指定のメモが見つかりませんでした'] }
      actual = JSON(response.body).symbolize_keys
      expect(response.status).to eq 404
      expect(actual).to eq expected
    end

    it 'はkeyが存在するがrevisionが存在しない場合、ステータス404を返す (404)' do
      get :show, { key: 'test-pad1', revision: '9999-9999-9999' }
      expected = { errors: ['指定のメモが見つかりませんでした'] }
      actual = JSON(response.body).symbolize_keys
      expect(response.status).to eq 404
      expect(actual).to eq expected
    end
  end

  describe 'PUT update' do
    it 'は与えられたパラメータで仮の@padを作成して保存する (200)' do
      put :update, { key: 'test-pad1', content: 'Hello!', is_autosaved: false }
      expect(response.status).to eq 200
    end

    it 'はパラメータが不足しているとステータス400を返す (400)' do
      put :update, { key: 'test-pad1', content: nil, is_autosaved: false }
      expected = { errors: ['本文は1文字以上で入力してください。'] }
      actual = JSON(response.body).symbolize_keys
      expect(response.status).to eq 400
      expect(actual).to eq expected
    end
  end
end
