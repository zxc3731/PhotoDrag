# PhotoDrag
iOS实现图片的捏合拖动，调整图像位置，代码已经实现截取当前显示图片区域的功能
```Objective-C
  HLFragmentDragView *vi = [[HLFragmentDragView alloc] initWithFrame:CGRectMake(0, 30, 320, 320) withImages:@[[UIImage imageNamed:@"1"], [UIImage imageNamed:@"2"], [UIImage imageNamed:@"3"]]];
  [self.view addSubview:vi];
```
![](https://github.com/zxc3731/PhotoDrag/blob/PhotoDrag/1.gif)

