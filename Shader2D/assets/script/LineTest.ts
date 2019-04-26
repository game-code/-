
const { ccclass, property } = cc._decorator;

@ccclass
export default class LineTest extends cc.Component {

    @property(cc.Graphics) lines: cc.Graphics = null

    // LIFE-CYCLE CALLBACKS:

    onLoad() {
        this.lines = this.node.getComponent(cc.Graphics);
    }

    start() {
        if (this.lines) {
            this.lines.clear(true)
            this.lines.moveTo(-200, -200);
            this.lines.lineTo(0, -100);
            this.lines.moveTo(0, -100);
            this.lines.lineTo(200, 100);
            this.lines.moveTo(200, 100);
            this.lines.lineTo(350, -300);
            this.lines.stroke()
        }
    }

    // update (dt) {},
}
