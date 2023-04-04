export class Category {
    constructor(obj) {
      obj = obj != null ? obj : {}
      this.id = obj.id != null ? obj.id : null
      this.name = obj.name != null ? obj.name : ''
      this.primaryEffect = obj.primaryEffect != null ? obj.primaryEffect : ''
      this.secondaryEffect = obj.secondaryEffect!= null ? obj.secondaryEffect : ''
      this.medications = []
  }
}