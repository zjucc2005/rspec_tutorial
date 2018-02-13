# encoding: utf-8

# 本示例用来展示几种典型的url请求和其返回消息类型
# 只是样例代码,如果要执行,需要结合Padrino

# 1. 通过脚手架生成controller/helper和对应的rspec文件
# $ padrino g controller home
# create  app/controllers/home.rb
# create  app/views/home
#  apply  tests/rspec
# create  spec/app/controllers/home_controller_spec.rb
# create  app/helpers/home_helper.rb
#  apply  tests/rspec
# create  spec/app/helpers/home_helper_spec.rb

# 2. 编写 app/controllers/home.rb
ProjectName::App.controllers :home do

    # GET, 渲染页面, 返回 text/html
    get :get_html_test, :map => '/get_html_test' do
        render 'home'
        # 模板文件 home.html.erb 中的内容是 <h1>Hi, I am RSpec.</h1>
    end

    # GET, 有参数, 返回 text/html
    get :get_string_test, :with => :name, :map => '/get_string_test' do
        "Hi, #{params[:name]}."
    end

    # GET, 返回 application/json, 需指定 :provides => [:json]
    get :get_json_test, :map => '/get_json_test', :provides => [:json] do
        render :erb, params.to_json
    end

    # POST, 返回 application/json
    post :post_params_test, :map => '/post_params_test', :provides => [:json] do
        render :erb, { status: 'succ', params: params }.to_json
    end

    # GET, 重定向
    get :redirect_test, :map => '/redirect_test' do
        redirect(url(:home, :get_html_test))
    end
end

# 3. 编写 spec/app/controllers/home_controller_spec.rb
describe '/home' do

    it 'get_html_test render home.html.erb' do
        get '/get_html_test'
        expect(last_response.status).to eq 200
        expect(last_response.body).to include('Hi, I am RSpec.')
    end

    it 'get_string_test/:name' do
        get '/get_string_test'
        expect(last_response.status).to eq 404
        get '/get_string_test/rspec'
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq 'Hi, rspec.'
    end

    it 'get_json_test with valid format' do
        %w(/get_json_test /get_json_test.json).each do |path|
            get path
            expect(last_response.status).to eq 200
        end
        get '/get_json_test.json?a=first&b=second'
        expect(last_response.status).to eq 200
        expect(last_response.content_type).to eq 'application/json'
        expect(last_response.body).to eq '{"a":"first","b":"second","format":"json"}'
    end

    it 'get_json_test with invalid format' do
        %w(/get_json_test.js /get_json_test.xml).each do |path|
            get path
            expect(last_response.status).to eq 404
        end
    end

    it 'post_params_test' do
        # need to set :protect_from_csrf, false
        # or get authenticity token(user login) before expect
        headers = { 'ACCEPT' => 'application/json' }
        post '/post_params_test', {a: 'first', b: 'second'}, headers
        expect(last_response.status).to eq 200
        expect(last_response.content_type).to eq 'application/json'
        expect(last_response.body).to eq '{"status":"succ","params":{"a":"first","b":"second","format":null}}'
    end

    it 'redirect_test' do
        get '/redirect_test'
        expect(last_response.status).to eq 302
    end
end

