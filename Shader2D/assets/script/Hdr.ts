const { ccclass, property } = cc._decorator;

@ccclass
export default class Hdr extends cc.Component {

    //@property(cc.Vec2) posArr:cc.Vec2[] = [];
    @property
    fragShader: string = 'mohu';
    @property(cc.Sprite) shaderSpr: cc.Sprite = null;
    @property(cc.SpriteFrame) shaderNormalSpr: cc.SpriteFrame = null; // 法线贴图
    @property(cc.SpriteFrame) shaderDiffuseSpr: cc.SpriteFrame = null; // 漫反射贴图

    posArr: cc.Vec2[] = [];

    default_vert = `
    attribute vec4 a_position;
    attribute vec2 a_texCoord;
    attribute vec4 a_color;
    varying vec2 v_texCoord;
    varying vec4 v_fragmentColor;
    void main()
    {
        gl_Position = CC_PMatrix * a_position;
        v_fragmentColor = a_color;
        v_texCoord = a_texCoord;
    }
    `;

    isUse: boolean;
    isOk: boolean = false;
    program: cc.GLProgram;
    frag_glsl: string = '';
    startTime: number = Date.now();
    time: number = 0;
    resolution = { x: 0.0, y: 0.0 };
    // 初始化
    onLoad() {
        // this.shaderSpr.sizeMode = cc.Sprite.SizeMode.CUSTOM;
        // let size = cc.winSize.width > cc.winSize.height ? cc.winSize.width : cc.winSize.height;
        // this.shaderSpr.node.width = size;
        // this.shaderSpr.node.height = size;
        // this.shaderSpr.node.active = false;
        //cc.director.setDisplayStats(true);
        this.resolution.x = (this.node.getContentSize().width);
        this.resolution.y = (this.node.getContentSize().height);
        let self = this;
        cc.loader.loadRes(this.fragShader, function (err, data) {
            if (err)
                cc.log(err);
            else {
                self.frag_glsl = data;
                self.isUse = false;
                self.isOk = true;
                self.useShader();
            }
        });
    }

    setPos(pos: cc.Vec2[]) {
        if (pos.length > 0) {
            this.posArr = pos.slice();
        }
    }

    useShader() {
        if (!this.isOk) {
            cc.log('资源加载中。。。')
            return;
        }
        let texture1Normal = this.shaderNormalSpr.getTexture();
        let gltext1Normal = texture1Normal._glID;
        if (texture1Normal) {
            if (cc.sys.isNative) {
            }
            else {
                cc.gl.bindTexture2DN(1, texture1Normal);
            }
        }

        let texture1Diffuse = this.shaderDiffuseSpr.getTexture();
        let gltext1Diffuse = texture1Diffuse._glID;
        if (texture1Diffuse) {
            if (cc.sys.isNative) {
            }
            else {
                cc.gl.bindTexture2DN(2, texture1Diffuse);
            }
        }
        this.program = new cc.GLProgram();
        if (cc.sys.isNative) {
            this.program.initWithString(this.default_vert, this.frag_glsl);
        } else {
            this.program.initWithVertexShaderByteArray(this.default_vert, this.frag_glsl);
            this.program.addAttribute(cc.macro.ATTRIBUTE_NAME_POSITION, cc.macro.VERTEX_ATTRIB_POSITION);
            this.program.addAttribute(cc.macro.ATTRIBUTE_NAME_COLOR, cc.macro.VERTEX_ATTRIB_COLOR);
            this.program.addAttribute(cc.macro.ATTRIBUTE_NAME_TEX_COORD, cc.macro.VERTEX_ATTRIB_TEX_COORDS);
        }
        this.program.link();
        this.program.updateUniforms();
        this.program.use();

        this.isUse = true;
        if (cc.sys.isNative) {
            var glProgram_state = cc.GLProgramState.getOrCreateWithGLProgram(this.program);
            glProgram_state.setUniformFloat("time", this.time);
            glProgram_state.setUniformVec2("resolution", this.resolution);
            glProgram_state.setUniformInt("posArrLength", this.posArr.length);
            glProgram_state.setUniformTexture("texturenormal", gltext1Normal);
            glProgram_state.setUniformTexture("textureemissive", gltext1Diffuse);
            for (let i = 0; i < this.posArr.length; ++i) {
                let pos = { x: this.posArr[i].x / 1.0, y: this.posArr[i].y / 1.0 }
                glProgram_state.setVec2("posArr" + i, pos);
            }
        } else {
            let ba = this.program.getUniformLocationForName("time");
            let res = this.program.getUniformLocationForName("resolution");
            let arrl = this.program.getUniformLocationForName("posArrLength");
            let text1normal = this.program.getUniformLocationForName("texturenormal");
            let text1diffuse = this.program.getUniformLocationForName("textureemissive");
            this.program.setUniformLocationWith1f(ba, this.time);
            this.program.setUniformLocationWith2f(res, this.resolution.x, this.resolution.y);
            this.program.setUniformLocationWith1i(arrl, this.posArr.length);
            this.program.setUniformLocationWith1i(text1normal, 1);
            this.program.setUniformLocationWith1i(text1diffuse, 2);
            for (let i = 0; i < this.posArr.length; ++i) {
                let pos = this.program.getUniformLocationForName("posArr" + i);
                this.program.setUniformLocationWith2f(pos, this.posArr[i].x / 1.0, this.posArr[i].y / 1.0);
            }
        }
        this.shaderSpr.node.active = true;
        this.setProgram(this.shaderSpr._sgNode, this.program);
    }

    initShader() {

    }

    setProgram(node: any, program: any) {
        if (cc.sys.isNative) {
            var glProgram_state = cc.GLProgramState.getOrCreateWithGLProgram(program);
            node.setGLProgramState(glProgram_state);
        } else {
            node.setShaderProgram(program);
        }
    }

    updateParameters() {
        this.time = (Date.now() - this.startTime) / 1000;
    }

    // 每帧更新函数
    update() {
        if (!this.isUse) {
            return;
        }
        this.updateParameters();
        if (this.program) {
            this.program.use();
            if (cc.sys.isNative) {
                var glProgram_state = cc.GLProgramState.getOrCreateWithGLProgram(this.program);
                glProgram_state.setUniformFloat("time", this.time);
            } else {
                let ct = this.program.getUniformLocationForName("time");
                this.program.setUniformLocationWith1f(ct, this.time);
            }
        }
    }
}
