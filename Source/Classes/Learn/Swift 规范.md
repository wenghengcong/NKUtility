#  规范
https://github.com/raywenderlich/swift-style-guide


1. Dictionary和数组之类的容器对象需要变量声明类型。不声明类型的容器对象会导致编译时长增加一秒左右
2. String和array等对象不要用”+“拼接串联，String用“+”拼接会大幅增加编译速度
3. 在if等逻辑判断语句中不要进行“+-/”计算操作
