import { ProductRe } from '../models/httpResult';

// 实现IDataSource接口的对象，用于瀑布流组件加载数据
export class WaterFlowDataSource implements IDataSource {
  private dataArray: ProductRe[] = [];
  private listeners: DataChangeListener[] = [];

  // 添加数据
  addSource(obj: ProductRe) {
    this.dataArray.push(obj);
    console.log(`商品信息添加为：${obj.product_name} + ${obj.product_price} `)
  }

  // 获取索引对应的数据
  public getData(index: number): ProductRe {
    return this.dataArray[index];
  }

  // 通知控制器数据重新加载
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知控制器数据增加
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // 通知控制器数据变化
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知控制器数据删除
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  // 通知控制器数据位置变化
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }

  //通知控制器数据批量修改
  notifyDatasetChange(operations: DataOperation[]): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange(operations);
    })
  }

  // 获取数据总数
  public totalCount(): number {
    return this.dataArray.length;
  }

  // 注册改变数据的控制器
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  // 注销改变数据的控制器
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  // 增加数据
  public add1stItem(obj: ProductRe): void {
    this.dataArray.splice(0, 0, obj);
    this.notifyDataAdd(0);
  }

  // 在数据尾部增加一个元素
  public addLastItem(obj: ProductRe): void {
    this.dataArray.splice(this.dataArray.length, 0, obj);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  // 在指定索引位置增加一个元素
  public addItem(index: number, obj: ProductRe): void {
    this.dataArray.splice(index, 0, obj);
    this.notifyDataAdd(index);
  }

  // 删除第一个元素
  public delete1stItem(): void {
    this.dataArray.splice(0, 1);
    this.notifyDataDelete(0);
  }

  // 删除第二个元素
  public delete2ndItem(): void {
    this.dataArray.splice(1, 1);
    this.notifyDataDelete(1);
  }

  // 删除最后一个元素
  public deleteLastItem(): void {
    this.dataArray.splice(-1, 1);
    this.notifyDataDelete(this.dataArray.length);
  }

  // 在指定索引位置删除一个元素
  public deleteItem(index: number): void {
    this.dataArray.splice(index, 1);
    this.notifyDataDelete(index);
  }

  // 重新加载数据
  public reload(): void {
    this.dataArray.splice(1, 1);
    this.dataArray.splice(3, 2);
    this.notifyDataReload();
  }

  public deleteAll(): void {
    // for (let cnt = 0; cnt < this.dataArray.length; cnt++) {
    this.dataArray.splice(0, this.dataArray.length)
    // }
  }

  // 在数据尾部增加count个元素
  // public addNewItems(count: number): void {
  //   let len = this.dataArray.length;
  //   for (let i = 0; i < count; i++) {
  //     this.dataArray.push(this.dataArray[len - 1] + i + 1);
  //     this.notifyDataAdd(this.dataArray.length - 1);
  //   }
  // }

  // 刷新所有元素
  // public refreshItems(): void {
  //   let newDataArray: number[] = [];
  //   for (let i = 0; i < 100; i++) {
  //     newDataArray.push(this.dataArray[0] + i + 1000);
  //   }
  //   this.dataArray = newDataArray;
  //   this.notifyDataReload();
  // }
}

export enum FooterState {
  Loading = 0,
  End = 1
}
