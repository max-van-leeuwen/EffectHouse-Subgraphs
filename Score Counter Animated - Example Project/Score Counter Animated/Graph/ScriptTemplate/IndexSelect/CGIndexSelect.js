const {BaseNode} = require('./BaseNode');
const Amaz = effect.Amaz;

class CGIndexSelect extends BaseNode {
  constructor() {
    super();
  }

  clamp(value, min, max) {
    return Math.min(max, Math.max(value, min));
  }

  getOutput(index) {
    const len = this.inputs.length - 1;
    const itemIndex = this.clamp(Math.round(this.inputs[0]()), 0, len - 1);
    return this.inputs[1 + itemIndex]();
  }
}

exports.CGIndexSelect = CGIndexSelect;
