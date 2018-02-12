# encoding: utf-8

# 本示例用来展示模型 class User < ActiveRecord::Base 的验证,创建,修改,删除等基本内容的测试用例
# 只是样例代码,如果要执行,需要结合web框架(如: Padrino)
class User < ActiveRecord::Base
    validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
    validates :name, presence: true, length: { maximum: 50 }
    validates :age, numericality: { greater_than: 0 }

    def say_hi
        "Hi, I am #{name}."
    end

    def self.raise_an_error
        raise NameError, 'name error'
    end
end

describe User do

    # 测试开始前,清空users表
    before(:all) { User.delete_all }
    # 创建一个可以在所有用例里被调用的对象 user
    let(:user) { User.new(email: 'rspec@example.com', name: 'rspec', age: 10) }

    # 模型验证测试
    it 'should be present' do
        expect(user).not_to be_nil
    end

    it 'should be valid' do
        expect(user).to be_valid
    end

    # email正确格式测试
    it 'should accept valid email' do
        valid_emails = %w(user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn)
        valid_emails.each do |email|
            user.email = email
            expect(user).to be_valid
        end
    end

    # email错误格式测试
    it 'should reject invalid email' do
        invalid_emails = %w(user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com)
        invalid_emails += ['   ', nil]
        invalid_emails.each do|email|
            user.email = email
            expect(user).to be_invalid
        end
    end

    # email唯一性测试
    it 'email should be unique' do
        duplicate_user = user.dup
        user.save
        expect(duplicate_user).to be_invalid
        user.destroy
    end

    # name存在性测试
    it 'name should be present' do
        ['   ', nil].each do |name|
            user.name = name
            expect(user).to be_invalid
        end
    end

    # name长度测试
    it 'name should not be too long' do
        user.name = 'a' * 51
        expect(user).to be_invalid
    end

    # age数值测试
    it 'age should be greater than 0' do
        [-1, 0].each do |age|
            user.age = age
            expect(user).to be_invalid
        end
    end

    # CRUD测试
    it 'should be able to create a valid user' do
        expect{ user.save! }.to change{ User.count }.by(1)
        # 也可以写成 expect{ user.save! }.to change(User, :count).by(1)
    end

    it 'should be able to find a user' do
        expect(User.first).not_to be_nil
    end

    it 'should be able to update a user' do
        user.update(name: 'update_test')
        expect(user.name).to eq('update_test')
    end

    it 'should be able to delete a user' do
        expect{ User.first.destroy }.to change{ User.count }.by(-1)
    end

    # 实例方法测试
    it '.say_hi' do
        expect(user.say_hi).to eq('Hi, I am rspec.')
    end

    # 类方法测试
    it '#raise_an_error' do
        expect{ User.raise_an_error }.to raise_error(NameError, 'name error')
    end
end
