const { ccclass, property } = cc._decorator;

enum eResultType { TEXT, ARRAYBUFFER }

export class Data {
    dis: number;
    angle: number;
}

@ccclass
export default class Test extends cc.Component {

    // LIFE-CYCLE CALLBACKS:
    @property(cc.Node) upNode: cc.Node = null
    @property(cc.Node) downNode: cc.Node = null
    @property([cc.Node]) posNode: cc.Node[] = []
    pos: cc.Vec2[] = []
    datas: Data[] = []
    angleArr: number[] = []

    onLoad() {
        cc.systemEvent.on(cc.SystemEvent.EventType.KEY_DOWN, this.onKeyDown, this);
        cc.systemEvent.on(cc.SystemEvent.EventType.KEY_UP, this.onKeyUp, this);
    }

    onKeyDown(event) {
        if (event.keyCode == cc.KEY.space) {
            this.node.runAction(cc.moveBy(20, 800, 0))
            this.upNode.runAction(cc.moveBy(20, 800, 0))
        }
    }

    onKeyUp(event) {

    }

    start() {
        // let posSelf = this.node.position
        // this.posNode.forEach((value, index) => {
        //     let otherPos = value.getPosition()
        //     this.pos.push(otherPos)
        //     let dis = cc.pDistance(otherPos, posSelf)
        //     let dir = otherPos.sub(posSelf).normalize()
        //     let sv = cc.p(1, 0)
        //     let angle = this.calculateVec2Angle(sv, dir)
        //     this.datas.push({ dis, angle })
        // })

        for (let i = 0; i < 9; ++i) {
            this.angleArr.push(22.5 * i)
        }

        // this.datas.sort((a, b) => {
        //     return a.dis - b.dis
        // })

        // cc.log(this.datas)
        // let val = this.getClosenNum(arr, 200)
        // cc.log(val, 10, arr)
    }

    rotateSelf(angle: number) {
        let gap = this.downNode.rotation - angle

        if (this.downNode.rotation == angle) {
            return
        } else {
            if (gap > 0) {
                this.upNode.rotation += 22.5
                this.downNode.rotation -= 22.5
            } else {
                this.downNode.rotation += 22.5
                this.upNode.rotation -= 22.5
            }
        }
    }

    tt: number = 0
    rotateTime: number = 0
    update(dt) {
        this.tt -= dt;
        if (this.tt < 0) {
            let posSelf = this.node.position
            this.datas = []
            this.pos = []
            this.posNode.forEach((value, index) => {
                let otherPos = value.getPosition()
                this.pos.push(otherPos)
                let dis = cc.pDistance(otherPos, posSelf)
                let dir = otherPos.sub(posSelf).normalize()
                let sv = cc.p(1, 0)
                let angle = this.calculateVec2Angle(sv, dir)
                this.datas.push({ dis, angle })
            })

            this.datas.sort((a, b) => {
                return a.dis - b.dis
            })
            this.tt = 1.
        }

        this.rotateTime -= dt;
        if (this.rotateTime < 0) {
            if (this.datas.length > 0) {
                let angle = this.datas[0].angle
                let targetAngle = this.getClosenNum(this.angleArr, angle)
                this.rotateSelf(targetAngle)
                // cc.log(angle, targetAngle, this.datas)
            }
            this.rotateTime = 0.2
        }
    }

    calculateVec2Angle(s: cc.Vec2, e: cc.Vec2): number {
        return this.radianToAngle(Math.acos(cc.pDot(s, e)))
    }

    angleToRadian(angle): number {
        return (Math.PI / 180) * angle
    }

    radianToAngle(radian): number {
        return (180 / Math.PI) * radian
    }

    getIntRandom(startNum: number, endNumber: number): number {
        let num = endNumber - startNum
        return startNum + Math.floor(Math.random() * num)
    }

    // 返回一个数组中最靠近num的值
    getClosenNum(arr: number[], num: number): number {
        let index = 0
        let tempArr: number[] = []
        arr.forEach((value, key) => {
            tempArr.push(Math.abs(value - num))
        })

        let temp = tempArr[0]
        tempArr.forEach((value, key) => {
            if (temp > value) {
                temp = value
                index = key
            }
        })

        return arr[index]
    }
}
