# RSpec Tutorial
![](http://rspec.info/images/logo.png)
## 开始吧, 先来Hello World!
1. 安装RSpec
```
$ gem install rspec
```
2. 新建第一个测试用例文件hello_world_spec.rb, 写入下面的代码
```
class HelloWorld

   def say_hello
      "Hello World!"
   end

end

describe HelloWorld do
   context "When testing the HelloWorld class" do

      it "should say 'Hello World' when we call the say_hello method" do
         hw = HelloWorld.new
         message = hw.say_hello
         expect(message).to eq "Hello World!"
      end

   end
end
```
3. 运行hello_world_spec.rb
```
$ rspec hello_world_spec.rb
.

Finished in 0.00231 seconds (files took 0.18998 seconds to load)
1 example, 0 failures
```

## 基本语法
### 1. 关键词 - 以上面的hello_world_spec.rb为例
```
# describe - 通常用来定义一组测试用例, describe的参数可以是类/字符串.
# 也可以写成 RSpec.describe HelloWorld{...}
describe HelloWorld do

   # context - 类似describe, 通常用来定义一类测试用例, context的参数可以是类/字符串.
   # 比如:
   # context "pass invalid params to User.new" {...}
   # context "pass valid params to my_method()" {...}
   # describe可以嵌套使用, 所以context用的相对较少
   context "When testing the HelloWorld class" do

      # it - 用来定义一个测试用例, it的参数可以是类/字符串, 目的在于表述清楚指定行为的预期结果
      # 英文表述,例 should do/return expected behaviour/outcome under/when specified condition
      # 中文表述,例 当某种条件时,应该做预期的行为/返回预期的结果
      it "should say 'Hello World' when we call the say_hello method" do
         hw = HelloWorld.new
         message = hw.say_hello

         # expect - 用来描述一个预期结果, 相当于unittest的assert
         # should - 在 expect(message).to 之前,老版本RSpec所用,句式message.should,现在还能兼容(以后会被弃用),建议用expect
         # expect(message) 会返回一个代理对象用来调用to, not_to等方法
         # should 是在Object类中定义的方法,能被所有对象调用
         # 相对expect这并不是一个好的做法,一是对ruby语言的破坏性较高, 二是会被后来定义的同名方法覆盖
         expect(message).to eq "Hello World!"
      end

   end
end
```
### 2. 匹配方法
hello_world_spec.rb 中用来描述预期结果的语句
```
expect(message).to eq "Hello World!"
# 加上括号后,语法结构更清晰
expect(message).to eq("Hello World!")
# :not_to 的用法和 :to 相反
expect(message).not_to eq("Goodbye!")
```
上面的 eq 是RSpec的匹配方法, 用来表示 message 与预期结果 "Hello World!" 相等. 除了 eq 之外, eql, be, equal 都是表示相等, 用法没有什么不同

```
describe "匹配方法测试" do

   it "eq/eql/be/equal应该都是表示相等" do
      a = "equality test"
      b = a

      # 下面的测试都会通过
      expect(a).to eq "equality test"
      expect(a).to eql "equality test"
      expect(a).to be b
      expect(a).to equal b
   end

end
```
* eq,eql,be,equal匹配的严格程度有略微区别: eq < eql < be = equal
* eq/:==, eql/:eql?, equal/:equal?, eq/:== 意思是 eq 就是按照ruby的 :== 方法进行相等的判断,以此类推
* 关于 :==, :eql?, :equal? 三者的区别:
1. :equal? 是同一个对象时(:__id__返回结果一致),返回true
2. :==, :eql? 是比较对象完全一致时(:__id__返回结果可以不同),返回true
3. 比较数值时 :eql? 区分 Float 和 Integer, :== 不区分
```
class Book; end
book1 = Book.new
book2 = Book.new
book1 == book2           # false
book1.eql? book2         # false
book1.equal? book2       # false

1 == 1.0                 # true
1.eql? 1.0               # false
1.equal? 1.0             # false

'string' == 'string'     # true
'string'.eql? 'string'   # true
'string'.equal? 'string' # false

a = 'test'
b = a
a == b                   # true
a.eql? b                 # true
a.equal? b               # true
```
|匹配方法|描述|例子|
| :- | :- | :- |
|eq| 当 :== 比较返回true时通过 |expect(actual).to eq expected|
|eql| 当 :eql? 比较返回true时通过 |expect(actual).to eql expected|
|be| 当 :equal? 比较返回true时通过 |expect(actual).to be expected|
|equal| 当 :equal? 比较返回true时通过 |expect(actual).to equal expected|
|>| 当 :> 比较返回true时通过 |expect(actual).to be > expected|
|be_between(min, max).inclusive| 当 >= min 且 <= max 时通过 |expect(actual).to be_between(min, max).inclusive|
|be_between(min, max).exclusive| 当 < min 且 > max 时通过 |expect(actual).to be_between(min, max).exclusive|
|match| 当匹配正则表达式时通过 |expect(actual).to match(/regex/)|
|be_instance_of| 当 obj.class == MyClass 为true时通过 |expect(actual).to be_instance_of(MyClass)|
|be_kind_of| 当 obj.is_a? MyClass 为true时通过 |expect(actual).to be_kind_of(MyClass)|
|respond_to| 当 obj.respond_to? :my_method 为true时通过 |expect(actual).to respond_to(:my_method)|
|be_truthy| 当不是false和nil时通过 |expect(actual).to be_truthy|
|be_falsey| 当是false或nil时通过 |expect(actual).to be_falsey|
|be_nil| 同 be nil |expect(actual).to be_nil|
|change{ object }.from(old).to(new)| 执行block前检查object是否是old,执行后检查是否new |expect{ block }.to change{ object }.from(old).to(new) |
|change{ object }.by(1)| 执行block前后检查object的值是否增加1 |expect{ block }.to change{ object }.by(1) |
|raise_error(ErrorClass)| 当block抛出ErrorClass异常时通过 |expect{ block }.to raise_error(ErrorClass)|
|raise_error('error message')| 当block抛出异常消息'error message'时通过 |expect{ block }.to raise_error('error message')|
|raise_error(ErrorClass,'error message')| 当block抛出ErrorClass异常且异常消息'error message'时通过 |expect{ block }.to (ErrorClass,'error message')|
* 注意! expect后面有传普通参数,也有传block的,注意区分!
* 除了上述匹配方法之外,还有一类匹配方法,原先并不存在,RSpec通过元编程的能力实现这类'幽灵方法',优化了代码的可读性,如下:
```
describe Book do
   let(:book) { Book.new }

   it 'should be valid' do
      # 按照上述匹配方法是这么写的
      expect(book.valid?).to be true
      # 但是RSpec允许你写成下面这样的形式,读起来更自然通顺.
      expect(book).to be_valid
   end

   # 继续一个例子
   it 'hash should has key :a' do
      hash = { a: 'first', b: 'second' }
      expect(hash.has_key?(:a)).to be true
      expect(hash).to be_has_key(:a)
   end

   # 是不是发现规律了, 虽然有些时候看起来并不是那么完美无缺, 但总结下就是
   # expect(obj.my_method?(*args)).to be true 可以改写成
   # expect(obj).to be_my_method(*args) 这种形式
   # :my_method? 的限制: 1. 方法名必须要以问号结尾; 2. 方法返回值是boolean
end
```

### 3. 模拟对象 - Test Doubles(RSpec Mocks)
* Test Double是一个模拟对象,在代码中模拟系统的另一个对象,方便测试.
* 例如,测试时需要一个书架的类(Bookshelf),可以自动列出所有书名的方法(:list_book_titles),如下:
```
class Bookshelf

   def initialize(*books)
      @books = books
   end

   def list_book_titles
      @books.map(&:title).join(', ')
   end

end
```
* 但书本类(Book)相关的代码还在开发中,不能使用.此时可以通过Test Double去模拟它.
```
book = double('Book')
# 也可以直接创建一个有属性的对象
book_1 = double('Book', title: 'Metaprogramming Ruby 2nd')
book_2 = double('Book', title: 'The RSpec Book')
```
* 下面是测试用例
```
describe Bookshelf do
   it 'should return correct book titles' do
      book_1 = double('Book', title: 'Metaprogramming Ruby 2nd')
      book_2 = double('Book', title: 'The RSpec Book')

      bookshelf = Bookshelf.new(book_1, book_2)
      expect(bookshelf.list_book_titles).to eq('Metaprogramming Ruby 2nd, The RSpec Book')
   end
end
```
### 4. 模拟方法 - Method Stubs
* Test Double是直接模拟一个不存在的类及其方法,但如果类已经存在,我们只需要模拟这个类的方法的话,该怎么做呢?
* RSpec也可以直接模拟真实对象的方法
```
class Book; end

book = Book.new

allow(:book).to receive(:title){ 'The RSpec Book' }

# 上述代码等同于
book = double('Book', title: 'The RSpec Book')
```
* Test Double 提供以下3种方式创建模拟方法
```
allow(:book).to receive(:title){ 'The RSpec Book' }
allow(:book).to receive(:title).and_return('The RSpec Book')
allow(:book).to receive_messages {
   :title => 'The RSpec Book',
   :version => '2010-11-24',
   :authors => ['David Chelimsky', 'Dave Astels', 'Zach Dennis']
}

# 如果方法带有参数
allow(:book).to receive(:title) do |format|
   case format
      when 'upcase' then 'THE RSPEC BOOK'
      when 'downcase' then 'the rspec book'
      else 'The RSpec Book'
   end
end
```
### 5. 钩子 - Hooks
* 当编写测试用例时,很多测试用例在开始前都要做一些准备工作,或者在结束后做一些数据的清理.
* 这些准备代码和清理代码在每一个测试用例里都写一遍一点显得都不优雅,为了便于维护修改,
* 这些代码需要在每个测试用例的开始结束时自动加载,减少代码的重复.
* 原则上,每个测试用例之间需要相互独立,通过钩子加载的代码不能对其他测试用例造成干扰.
* unit test 里通过 setup 和 teardown 来实现, RSpec也提供了一系列钩子来实现, 比如 before 和 after
```
class MyClass
   attr_accessor :message

   def initialize
      @message = 'hello'
   end
end

describe MyClass do
   before(:each) do
      @my_class = MyClass.new
   end

   it 'should have default message' do
      expect(@my_class.message).not_to be nil
   end

   it 'should be able to update message' do
      @my_class.message = 'bye'
      expect(@my_class.message).not_to eq('hello')
   end
end
```
* 上述简单例子中 before(:each) 表示在每一个测试用例运行前都会运行一次, after(:each) 同理
* 还有 before(:all), after(:all) 表示在所有测试用例运行之前/后运行, 仅一次
* 此外, 还有一种形式 let(:name){ block }
* let使用后面的block来创建一个对象,和before(:each)类似,区别是:
* 1. 一个let只能创建一个对象,以便后面测试代码直接调用,而before(:each)中可以做更多的操作;
* 2. let只会执行一遍,执行后会缓存创建后的对象,后续执行调用速度快;
* 所以上面的测试用例也可以写成:
```
describe MyClass do
   let(:my_class){ MyClass.new }

   it 'should have default message' do
      expect(my_class.message).not_to be nil
   end

   it 'should be able to update message' do
      my_class.message = 'bye'
      expect(my_class.message).not_to eq('hello')
   end
end
```
### 6. 标签 - Tags
RSpec可以给测试用例加上标签,默认情况下,RSpec会运行所有测试用例,但加上标签后,运行时就可以通过标签只运行某一组测试
```
# tags_test.rb
describe "How to run specific Examples with Tags" do
   it 'is a slow test', :slow => true do
      sleep 3
      puts 'This test is slow!'
   end

   it 'is a fast test', :fast => true do
      puts 'This test is fast!'
   end
end
```
```
$ rspec tags_test.rb --tag=slow
Run options: include {:slow=>true}
This test is slow!
.

Finished in 3 seconds (files took 0.08743 seconds to load)
1 example, 0 failures

```
## 共享测试用例
* 当写的测试代码越来越多时,我们会发现有很多类之间会有着类似的行为
* 这时可以用共享测试用例包装这一组行为,然后再其他的类测试里直接引用,减少重复
```
shared_examples_for "any pizza" do
   it "tastes really good" do
      expect(@pizza).to be_taste_really_good
   end

   it "is available by the slice" do
      expect(@pizza).to be_available_by_the_slice
   end
end
```
* 上述代码用shared_examples_for申明了一组共享测试用例'any pizza',
* 然后我们在其他测试用例组里通过 it_behaves_like 来引用它
```
describe "New York style thin crust pizza" do
   before(:each) do
      @pizza = Pizza.new(:region => 'New York', :style => 'thin crust')
   end

   it_behaves_like "any pizza"

   it "has a really great sauce" do
      expect(@pizza).to be_have_a_really_great_sauce
   end
end

describe "Chicago style stuffed pizza" do
   before(:each) do
      @pizza = Pizza.new(:region => 'Chicago', :style => 'stuffed')
   end

   it_behaves_like "any pizza"

   it "has a ton of cheese" do
      expect(@pizza).to be_have_a_ton_of_cheese
   end
end
```
## 测试用例组的嵌套
* 前面提到 describe 可以实现测试用例组嵌套,当测试用例越來越多时,将测试进行分组会更方便管理
* 下面是一个简单例子
```
describe 'outer' do
   describe 'inner' do
   end
end
```
* 定义在内层的'inner'可以看作是'outer'的子类,这意味着在'outer'中加载的模块, 申明的变量, 定义的方法, 以及before, after钩子方法都可以在inner中使用
* 如果 'outer', 'inner' 都有申明before, after, 执行顺序如下:
1.Outer before
2.Inner before
3.Test example
4.Inner after
5.Outer after
* 简单的验证一下,代码如下:
```
describe "outer" do
   before(:each) { puts "1 - outer before" }
   describe "inner" do
      before(:each) { puts "2 - inner before" }
      it { puts "3 - test example"}
      after(:each) { puts "4 - inner after" }
   end
   after(:each) { puts "5 - outer after" }
end
```
* 执行上述代码,得到如下结果,验证通过
```
1 - outer before
2 - inner before
3 - test example
4 - inner after
5 - outer after
.

Finished in 0.00175 seconds (files took 0.082 seconds to load)
1 example, 0 failures
```
## Advanced
* RSpec是一个非常棒的工具,通过上面介绍的基本语法,已经可以在工作中写出具有良好可读性的测试代码了.
但是RSpec的功能其实不止如此,它强大DSL可以编写出质量更高,可读性更强,更优雅的测试代码.
* 下面的网址是探讨使用RSpec的最佳实践,供参考:
[http://www.betterspecs.org/](http://www.betterspecs.org/)

