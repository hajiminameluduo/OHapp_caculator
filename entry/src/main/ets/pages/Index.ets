@Entry
@Component
struct Index {
  @State resultText: string = '0';      // 主显示区（当前输入或结果）
  @State processText: string = '';      // 过程显示区（例如：100 + 20）

  @State tempNumber: string = '';       // 临时存储
  @State previousNumber: number = 0;    // 前一个数字
  @State currentOperator: string = '';  // 当前运算符
  @State isNewCalculation: boolean = true; // 是否开始新一轮输入

  // 按钮布局
  private buttons: string[] = [
    'C', '÷', '×', 'DEL',
    '7', '8', '9', '-',
    '4', '5', '6', '+',
    '1', '2', '3', '=',
    '0', '.'
  ];

  build() {
    Column() {
      // --- 显示区域 (优化版) ---
      Column() {
        // 1. 新增：计算过程显示 (小字，灰色)
        Text(this.processText)
          .fontSize(30)
          .fontWeight(FontWeight.Normal)
          .fontColor('#787878') // 深灰色
          .textAlign(TextAlign.End)
          .width('100%')
          .padding({ right: 20, top: 20 })
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        // 2. 主结果显示 (大字，黑色)
        Text(this.resultText)
          .fontSize(70) // 稍微加大字体
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .textAlign(TextAlign.End)
          .width('100%')
          .padding({ right: 20, bottom: 10 })
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('100%')
      .height('35%')
      .justifyContent(FlexAlign.End) // 靠底对齐
      .backgroundColor('#F1F3F5')

      // --- 键盘区域 (保持不变) ---
      Grid() {
        ForEach(this.buttons, (item: string) => {
          GridItem() {
            this.ButtonComponent(item)
          }
          .columnStart(item === '0' ? 0 : undefined)
          .columnEnd(item === '0' ? 1 : undefined)
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr 1fr')
      .rowsGap(10)
      .columnsGap(10)
      .padding(15)
      .width('100%')
      .height('65%')
      .backgroundColor(Color.White)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  ButtonComponent(text: string) {
    Button() {
      Text(text)
        .fontSize(30)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.getButtonTextColor(text))
    }
    .width('100%')
    .height('100%')
    .type(ButtonType.Normal)
    .borderRadius(20)
    .backgroundColor(this.getButtonBackgroundColor(text))
    .onClick(() => {
      this.handleInput(text);
    })
  }

  getButtonTextColor(text: string): Color {
    return ['C', 'DEL', '÷', '×', '-', '+', '='].includes(text) ? Color.White : Color.Black;
  }

  getButtonBackgroundColor(text: string): ResourceColor {
    if (text === '=') return '#FF9F0A';
    if (['÷', '×', '-', '+'].includes(text)) return '#FF9F0A';
    if (['C', 'DEL'].includes(text)) return '#A5A5A5';
    return '#E5E5E5';
  }

  // --- 逻辑处理 (重点优化部分) ---

  handleInput(value: string) {
    // 1. 数字输入
    if (/[0-9]/.test(value)) {
      // 如果刚按完等号，开始全新的计算
      if (this.processText.includes('=')) {
        this.processText = '';
        this.previousNumber = 0;
        this.currentOperator = '';
        this.resultText = value;
        this.isNewCalculation = false;
        return;
      }

      if (this.isNewCalculation) {
        this.resultText = value;
        this.isNewCalculation = false;
      } else {
        if (this.resultText === '0') this.resultText = value;
        else this.resultText += value;
      }
      return;
    }

    // 2. 小数点
    if (value === '.') {
      if (this.processText.includes('=')) {
        this.processText = ''; // 清除旧过程
        this.resultText = '0.';
        this.isNewCalculation = false;
        return;
      }
      if (!this.resultText.includes('.')) {
        this.resultText += '.';
        this.isNewCalculation = false;
      }
      return;
    }

    // 3. 清除 (C) - 全部重置
    if (value === 'C') {
      this.resultText = '0';
      this.processText = ''; // 清空过程
      this.previousNumber = 0;
      this.currentOperator = '';
      this.isNewCalculation = true;
      return;
    }

    // 4. 删除 (DEL) - 修改当前输入
    if (value === 'DEL') {
      if (this.processText.includes('=')) return; // 结果状态下不允许部分删除

      if (this.resultText.length > 1) {
        this.resultText = this.resultText.slice(0, -1);
      } else {
        this.resultText = '0';
        this.isNewCalculation = true;
      }
      return;
    }

    // 5. 运算符 (+, -, ×, ÷)
    if (['+', '-', '×', '÷'].includes(value)) {
      // 连续计算支持 (例如 1+1+...)
      if (this.currentOperator && !this.isNewCalculation && !this.processText.includes('=')) {
        this.calculateResult(); // 先算出前一步结果
      }

      this.previousNumber = parseFloat(this.resultText);
      this.currentOperator = value;

      // 更新过程显示： "12 +"
      this.processText = `${this.resultText} ${value}`;

      this.isNewCalculation = true;
      return;
    }

    // 6. 等号 (=)
    if (value === '=') {
      if (this.currentOperator && !this.isNewCalculation) {
        // 更新过程显示： "12 + 5 ="
        this.processText = `${this.previousNumber} ${this.currentOperator} ${this.resultText} =`;
        this.calculateResult();
        this.currentOperator = ''; // 算完清除运算符
        this.isNewCalculation = true;
      }
    }
  }

  // 抽离计算逻辑
  calculateResult() {
    let currentNum = parseFloat(this.resultText);
    let result = 0;

    switch (this.currentOperator) {
      case '+': result = this.previousNumber + currentNum; break;
      case '-': result = this.previousNumber - currentNum; break;
      case '×': result = this.previousNumber * currentNum; break;
      case '÷':
        if (currentNum !== 0) result = this.previousNumber / currentNum;
        else {
          this.resultText = 'Error';
          this.isNewCalculation = true;
          return;
        }
        break;
    }
    // 简单处理精度并转字符串
    this.resultText = parseFloat(result.toFixed(8)).toString();
  }
}