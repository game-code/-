const { ccclass, property } = cc._decorator;

enum eResultType { TEXT, ARRAYBUFFER }

@ccclass
export default class Test extends cc.Component {

    // LIFE-CYCLE CALLBACKS:

    pos: cc.Vec2[] = []
    // onLoad () {},

    start() {
        for (let i = 0; i < 10; ++i) {
            this.pos.push(cc.p(Math.random() * 400, Math.random() * 400))
        }
    }

    update(dt) {
        let posSelf = this.node.position
        let minAngle = 180
        this.pos.forEach((value, key) => {
            let dir = value.sub(posSelf).normalize()
            let sv = cc.p(1, 0)
            let angle = this.calculateVec2Angle(sv, dir)
            minAngle = minAngle > angle ? angle : minAngle
            minAngle = Math.abs(minAngle)
            cc.log(minAngle)
        })
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
