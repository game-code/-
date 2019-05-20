const { ccclass, property } = cc._decorator;

@ccclass
export default class ShaderEffect extends cc.Component {

    //@property(cc.Vec2) posArr:cc.Vec2[] = [];
    @property
    fragShader: string = 'mohu';
    @property(cc.Sprite) shaderSpr: cc.Sprite = null;

    condition: number = 0

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
        // this.shaderDiffuseSpr.getTexture().setTexParameters(cc.Texture2D.Filter.NEAREST, cc.Texture2D.Filter.NEAREST,
        //     cc.Texture2D.WrapMode.REPEAT, cc.Texture2D.WrapMode.REPEAT);
        // this.shaderNormalSpr.getTexture().setTexParameters(cc.Texture2D.Filter.NEAREST, cc.Texture2D.Filter.NEAREST,
        //     cc.Texture2D.WrapMode.REPEAT, cc.Texture2D.WrapMode.REPEAT);
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

    start() {

    }

    useShader(isSrc: boolean = false) {
        if (!this.isOk) {
            cc.log('资源加载中。。。')
            return;
        }

        this.condition = isSrc ? 0 : 1

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
            glProgram_state.setUniformInt("condition", this.condition);
        } else {
            let ba = this.program.getUniformLocationForName("time");
            let res = this.program.getUniformLocationForName("resolution");
            let arrl = this.program.getUniformLocationForName("condition");
            this.program.setUniformLocationWith1f(ba, this.time);
            this.program.setUniformLocationWith2f(res, this.resolution.x, this.resolution.y);
            this.program.setUniformLocationWith1i(arrl, this.condition);
        }
        this.shaderSpr.node.active = true;
        this.setProgram(this.shaderSpr._sgNode, this.program);
    }

    setProgram(node: cc.SGNode, program: any) {
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
        if (!this.isUse || this.condition == 0) {
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
