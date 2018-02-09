# RSpec Tutorial

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

## 语法
1. 关键词 - 以上面的hello_world_spec.rb为例
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
2. 匹配方法
hello_world_spec.rb 中用来描述预期结果的语句
```
expect(message).to eq "Hello World!"
# 加上括号后,语法结构更清晰
expect(message).to eq("Hello World!")
# :not_to 的用法和 :to 相反
expect(message).not_to eq("Goodbye!")
```
上面的 eq 是RSpec的匹配方法, 用来表示 message 与预期结果 "Hello World!" 相等
除了 eq 之外, eql, be, equal 都是表示相等, 用法没有什么不同

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
eq,eql,be,equal匹配的严格程度有略微区别: eq < eql < be = equal
eq/:==, eql/:eql?, equal/:equal?, eq/:== 意思是 eq 就是按照ruby的 :== 方法进行相等的判断,以此类推
关于 :==, :eql?, :equal? 三者的区别:
1. :equal? 是同一个对象时(:__id__返回结果一致),返回true
2. :==, :eql? 是比较对象完全一致时(:__id__返回结果可以不同),返回true
3. 比较数值时 :eql? 区分 Float 和 Integer, :== 不区分
```
1 == 1.0     # true
1.eql? 1.0   # false
1.equal? 1.0 # false

'string' == 'string'     # true
'string'.eql? 'string'   # true
'string'.equal? 'string' # false

a = 'test'
b = a
a == b     # true
a.eql? b   # true
a.equal? b # true
```
|匹配方法|描述|例子|
| :- | :- | :- |
|eq| 当 :== 比较返回true时通过 |expect(obj).to eq expectation|
|eql| 当 :eql? 比较返回true时通过 |expect(obj).to eql expectation|
|be| 当 :equal? 比较返回true时通过 |expect(obj).to be expectation|
|equal| 当 :equal? 比较返回true时通过 |expect(obj).to equal expectation|
|>| 当 :> 比较返回true时通过 |expect(obj).to be > expectation|
|be_between(min, max).inclusive| 当 >= min 且 <= max 时通过 |expect(obj).to be_between(min, max).inclusive|
|be_between(min, max).exclusive| 当 < min 且 > max 时通过 |expect(obj).to be_between(min, max).exclusive|
|match| 当匹配正则表达式时通过 |expect(obj).to match(/regex/)|







