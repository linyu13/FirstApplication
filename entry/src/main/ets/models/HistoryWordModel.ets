class HistoryWordModel {
  public word: string

  constructor(word: string) {
    this.word = word
  }
}

const historyWordList: HistoryWordModel[] = [
  new HistoryWordModel('HarmonyOS'),
  new HistoryWordModel('实名认证'),
  new HistoryWordModel('HMS Core'),
  new HistoryWordModel('Serverless'),
  new HistoryWordModel('生态市场'),
  new HistoryWordModel('应用上架'),
  new HistoryWordModel('仓颉'),
  new HistoryWordModel('HUAWEI HiAI'),
  new HistoryWordModel('表盘'),
  new HistoryWordModel('推送'),
  new HistoryWordModel('主题')
]

export { HistoryWordModel, historyWordList }