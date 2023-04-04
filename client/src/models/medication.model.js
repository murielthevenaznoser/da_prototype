export class Medication {
    constructor(obj) {
      obj = obj != null ? obj : {}
      this.name = obj.name != null ? obj.name : ''
      this.component = obj.component != null ? obj.component : ''
      this.categoryId = obj.categoryId != null ? obj.categoryId : null;
  }
}