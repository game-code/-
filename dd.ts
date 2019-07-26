const { ccclass, property } = cc._decorator;

enum eResultType { TEXT, ARRAYBUFFER }

@ccclass
export default class NewClass extends cc.Component {

    @property(cc.Label)
    label: cc.Label = null;

    @property
    text: string = 'hello';

    // LIFE-CYCLE CALLBACKS:

    // onLoad () {},

    start() {

    }

    uploadFiles(forEachCb: (file, result) => void, resultType: eResultType = eResultType.TEXT) {
        if (!cc.sys.isBrowser) return
    }

    downloadFile(fileName: string, content: string) {
        if (!cc.sys.isBrowser) return

        let blob = new Blob([content])
        let link = document.createElement("a")
        link.innerHTML = fileName;
        link.download = fileName;
        link.href = URL.createObjectURL(blob)
        let body = document.getElementsByTagName("body")[0]
        body.appendChild(link)
        link.click()
        body.removeChild(link)
    }

    // update (dt) {},
}
