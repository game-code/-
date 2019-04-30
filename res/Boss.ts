
const { ccclass, property } = cc._decorator;

@ccclass
export default class Boss extends cc.Component {

    @property(cc.Node)
    boss: cc.Node = null;

    @property(cc.Node)
    bottom: cc.Node = null;

    @property(cc.Prefab)
    zidanPre: cc.Prefab = null;


    //
    pool: cc.NodePool = new cc.NodePool()
    // LIFE-CYCLE CALLBACKS:

    onLoad() {
        for (let i = 0; i < 20; ++i) {
            this.putZidan(cc.instantiate(this.zidanPre))
        }
    }

    start() {
        this.schedule(() => {
            this.bottomShoot()
        }, 0.1)
    }

    shoot() {
        let z = this.getZidan()
        z.parent = this.node
        z.position = this.boss.position
        this.zidanFun(z)
    }

    bottomShoot() {
        let z = this.getZidan()
        z.parent = this.node
        z.position = this.bottom.position
        this.bzidanFun(z)
    }

    putZidan(node: cc.Node) {
        if (node) {
            this.pool.put(node)
        }
    }

    getZidan(): cc.Node {
        let node = null
        if (this.pool.size() <= 0) {
            let zidan = cc.instantiate(this.zidanPre)
            this.pool.put(zidan)
        }
        node = this.pool.get()

        return node
    }

    zidanFun(z: cc.Node) {
        let angle = 200
        let r = Math.random() * angle - angle / 2
        z.rotation = -r;
        let arr = []
        arr.push(cc.moveBy(1, cc.p(-200, r)))
        arr.push(cc.moveBy(2, cc.p(0, 100)))
        arr.push(cc.callFunc(() => {
            this.putZidan(z)
        }))
        // arr[0].easing(cc.easeBackIn())
        z.runAction(cc.sequence(arr))
    }

    bzidanFun(z: cc.Node) {
        let angle = 200
        let r = Math.random() * angle - angle / 2
        // z.rotation = -r;
        let arr = []
        arr.push(cc.moveBy(1, cc.p(-200 + r, 200)))
        arr.push(cc.moveBy(2, cc.p(0, -500)))
        arr.push(cc.callFunc(() => {
            this.putZidan(z)
        }))
        // arr[0].easing(cc.easeBackIn())
        z.runAction(cc.sequence(arr))
    }
    // update (dt) {},
}
