const {BaseNode} = require('./BaseNode');
const Amaz = effect.Amaz;

class CGCounter extends BaseNode {
  constructor() {
    super();
    this.value = 0;
  }

  beforeStart(sys) {
    this.value = this.inputs[4]();
  }

  inRange(from, to, value) {
    if (from <= to) {
      return from <= value && value <= to;
    } else {
      return from >= value && value >= to;
    }
  }

  clamp(from, to, value) {
    if (from <= to) {
      return Math.min(to, Math.max(from, value));
    } else {
      return Math.min(from, Math.max(to, value));
    }
  }

  execute(index) {
    const step = this.inputs[3]();
    const from = this.inputs[4]();
    const to = this.inputs[5]();

    this.value = this.clamp(from, to, this.value);

    if (index === 0) {
      if (this.inRange(from, to, this.value + step)) {
        this.value = this.value + step;
      }
    } else if (index === 1) {
      if (this.inRange(from, to, this.value - step)) {
        this.value = this.value - step;
      }
    } else if (index === 2) {
      this.value = from;
    }
    if (this.nexts[0]) {
      this.nexts[0]();
    }
  }

  getOutput(index) {
    return this.value;
  }
}

exports.CGCounter = CGCounter;
