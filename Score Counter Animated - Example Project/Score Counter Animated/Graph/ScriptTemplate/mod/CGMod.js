/**
 * @file CGMod.js
 * @author liujiacheng
 * @date 2021/8/23
 * @brief CGMod.js
 * @copyright Copyright (c) 2021, ByteDance Inc, All Rights Reserved
 */

const {BaseNode} = require('./BaseNode');
const Amaz = effect.Amaz;

class CGMod extends BaseNode {
  constructor() {
    super();
  }

  setNext(index, func) {
    this.nexts[index] = func;
  }

  setInput(index, func) {
    this.inputs[index] = func;
  }

  getOutput() {
    return this.inputs[0]() % this.inputs[1]();
  }
}

exports.CGMod = CGMod;
