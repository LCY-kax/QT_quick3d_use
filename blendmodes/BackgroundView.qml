/****************************************************************************
**
** Copyright (C) 2019 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.14
import QtQuick3D 1.14
import QtQuick3D.Materials 1.14
import QtQuick.Particles 2.0

View3D {
    id :view3d
    property real moveStep: 10
    property int dx:0
    property int dz:0
    property bool wKeyPressed: false
    property bool aKeyPressed: false
    property bool sKeyPressed: false
    property bool dKeyPressed: false
    property bool mousePressed: false
    property bool spacePressed: false
    property var startPos:Qt.point(0, 0)
    property var mouseindex:Qt.point(0, 0)
    property var mouseStar:Qt.point(0, 0)
    property bool oneclick : true
    property var result

    //! [background]
    environment: SceneEnvironment {
        clearColor: "#848895"
        backgroundMode: SceneEnvironment.Color
//        backgroundMode: SceneEnvironment.Skybox
    }
    //! [background]

    DirectionalLight {
        id:light
        x: 100
        y: 300
        brightness: 250
        color: "white"
         z: 0
         rotation:Qt.vector3d(0, 45, 0)
         castsShadow: true
//         shadowFactor:5
//         shadowMapQuality : Light.shadowMapQualityHigh

    }
    SequentialAnimation {
        running: true
        loops: Animation.Infinite
        ParallelAnimation {
            NumberAnimation { target: light; property: "rotation.y"; to: 360; duration:4000 }
        }
        ParallelAnimation {
            NumberAnimation { target: light; property: "rotation.y"; to: 0; duration: 4000 }
        }
    }

    PointLight{
    y:250
    constantFade:1
    linearFade: 0.01
    quadraticFade: 0.0001
    castsShadow: true
    }
    Node{
        id:perCamera
        z:-500
        x:0
        y:0
        PerspectiveCamera {
            id:perCamera_C
            //        z:-500
            //        x:0
            //        y:0
            y:80
            rotation:Qt.vector3d(15, 0, 0)
        }

    Model {
        z:150
        y:-95
        id: man
        scale:Qt.vector3d(0.7 ,0.7, 0.7)
        source: "qrc:/obj/man.mesh"
        rotation: Qt.vector3d(90, 90, 0)

        DefaultMaterial {
            id: node01___Default_material
            diffuseColor: "#ffbebebe"
        }
        materials: [
            node01___Default_material
        ]
    }
}
    focus: true

    Keys.onPressed: {
        if (event.key === Qt.Key_A) {
            aKeyPressed = true
//            moveCamera()//a
        }else if (event.key === Qt.Key_D) {
            dKeyPressed = true
//            moveCamera()//d
        } else if (event.key === Qt.Key_W) {
            wKeyPressed = true
//            moveCamera()//w
        } else if (event.key === Qt.Key_S) {
            sKeyPressed = true
//            moveCamera()//s
        }
        if(event.key === Qt.Key_Space){
            spacePressed = true
        }
        if(event.key === Qt.Key_Right){
            if(!oneclick){
                car.rotation.y=(car.rotation.y-3)% -360
            }
        }
        if(event.key === Qt.Key_Left){
            if(!oneclick){
                car.rotation.y=(car.rotation.y+3)% 360
            }
        }
    }
    Keys.onReleased: {
        if (event.key === Qt.Key_A) {
            aKeyPressed = false
        } else if (event.key === Qt.Key_D) {
            dKeyPressed = false
        } else if (event.key === Qt.Key_W) {
            wKeyPressed = false
        } else if (event.key === Qt.Key_S) {
            sKeyPressed = false
        }
        if(event.key === Qt.Key_Space){
//            spacePressed = false
        }
    }
    Timer {
        id: frameTimer
        interval: 16 // 设置每帧的间隔时间，16ms 对应大约 60fps
        repeat: true
        running: (aKeyPressed || dKeyPressed || wKeyPressed || sKeyPressed)?true:false
        onTriggered: {
            moveCamera();
        }
    }
    function moveCamera() {
        dx=0
        dz=0
        if (sKeyPressed)
            dz-=moveStep
        if (wKeyPressed)
            dz+=moveStep
        if (dKeyPressed)
            dx+=moveStep
        if (aKeyPressed)
            dx-=moveStep
//            console.log("=====wKeyPressed====="+wKeyPressed+"=====sKeyPressed====="+sKeyPressed+"=====aKeyPressed====="+aKeyPressed+"=====dKeyPressed====="+dKeyPressed+"/n")
//             console.log("=====dz====="+dz+"=====dx====="+dx+"/n")
//            animation.start();
        var world_dx = dx *Math.cos(perCamera.rotation.y* Math.PI / 180) + dz *Math.sin(perCamera.rotation.y* Math.PI / 180);
        var world_dz = -dx *Math.sin(perCamera.rotation.y* Math.PI / 180) + dz *Math.cos(perCamera.rotation.y* Math.PI / 180);
         perCamera.position = Qt.vector3d(perCamera.position.x + world_dx, perCamera.position.y, perCamera.position.z + world_dz);

//        console.log("====== perCamera.position===="+ perCamera.position)
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {
            mousePressed = true
            startPos =Qt.point(mouse.x, mouse.y)
             mouseStar = Qt.point(mouse.x,mouse.y)
           }
        onReleased: {
            mousePressed = false
        }
          // 鼠标移动事件
        onPositionChanged: {
            mouseStar = Qt.point(mouse.x,mouse.y)
//            console.log(mouseStar)
            if (mousePressed) {
                mouseindex = Qt.point(mouse.x-startPos.x, mouse.y-startPos.y)
                if(mouseindex.x>0){
                    perCamera.rotation.y=(perCamera.rotation.y+3 )% 360
                    startPos =Qt.point(mouse.x, mouse.y)//更新坐标
                }else if (mouseindex.x<0){
                    perCamera.rotation.y=(perCamera.rotation.y-3 )% -360
                    startPos =Qt.point(mouse.x, mouse.y)//更新坐标
                }
//                console.log("==========perCamera.rotation.y========="+perCamera.rotation.y)
//                console.log("==========Math.cos(perCamera.rotation.y)========="+Math.cos(perCamera.rotation.y))
//                console.log("=======Qt.point(mouse.x, mouse.y)==========="+Qt.point(mouse.x, mouse.y))
            }

        }
        onClicked:{
             result =view3d.pick(mouse.x,mouse.y)
//            console.log("======pick  result========"+result)
//            console.log(result.objectHit)
            if(result.objectHit){//单击处存在对象
                var selectModel = result.objectHit;//定义模型
//                console.log(selectModel.objectName)
                if(selectModel.objectName === "car"){//car是某一模型的objectName
//                    console.log("mouse click car");
                    if(oneclick){
                    selectModel.materials=[
                                node02___PrincipledMaterial
                            ]
                        oneclick=false
                    }else{
                        car.materials=[
                                    node02___Default_material
                                ]
                        oneclick=true
                    }
                }
            }
            else{//单击处没有对象
//                console.log("mouse click other area");

            }
        }
    }

    Rectangle{
        x:mouseStar.x-5
        y:mouseStar.y-5
        width: 12
        height: 12
        color:"transparent"
//        visible:mousePressed
        ParticleSystem{
            anchors.fill: parent
            ImageParticle {
                groups: ["stars"]
                anchors.fill: parent
                source: "qrc:/image/star.png"
                alpha:0.8
                alphaVariation:0.2
                autoRotation:true
                color:"grey"
                colorVariation:1.0
            }
            Emitter {
                enabled:mousePressed
                maximumEmitted:parent.width
                group:"stars"
                emitRate: parent.width/2
                lifeSpan:2000
                lifeSpanVariation:1000
                size:10
                sizeVariation: 8
                anchors.fill: parent
            }
            Turbulence {
                anchors.fill: parent
                strength: 5
            }
        }
    }


    SequentialAnimation {
        id:jump
        running: spacePressed
        ParallelAnimation {
            NumberAnimation { target: perCamera; property: "y"; to: 250; duration:1200 ; easing.type:Easing.OutQuad}
        }
        ParallelAnimation {
            NumberAnimation { target: perCamera; property: "y"; to: 0; duration: 1000 ;easing.type:Easing.InQuad}
        }
//        onStopped: { spacePressed = false }
        onFinished:{ spacePressed = false }
    }

//        PropertyAnimation{
//            id:animation
//            duration:200
//            target: perCamera
//            property: "position"
//            easing.type:Easing.Linear //Easing.InQuad //Easing.OutQuad
//            running:false
////            from:0
//            to:Qt.vector3d(perCamera.x + dx, perCamera.y, perCamera.z+ dz)
//        }

//    SequentialAnimation {
//        running: true
//        loops: Animation.Infinite
//        ParallelAnimation {
//            NumberAnimation { target: perCamera; property: "x"; to: 300; duration:4000 }
//        }
//        ParallelAnimation {
//            NumberAnimation { target: perCamera; property: "x"; to: 0; duration: 4000 }
//        }
//        ParallelAnimation {
//            NumberAnimation { target: perCamera; property: "x"; to: -300; duration: 4000 }
//        }
//        ParallelAnimation {
//            NumberAnimation { target: perCamera; property: "x"; to: 0; duration: 4000 }
//        }
//    }

//    SequentialAnimation {
//        running: true
//        loops: Animation.Infinite
//        ParallelAnimation {
//            NumberAnimation { target: perCamera; property: "z"; to: -200; duration:6000 }
//        }
//        ParallelAnimation {
//            NumberAnimation { target: perCamera; property: "z"; to: -600; duration: 6000 }
//        }
//    }
//    SequentialAnimation {
//        running: true
//        loops: Animation.Infinite
//        ParallelAnimation {
//            NumberAnimation { target: perCamera; property: "y"; to: 200; duration:4000 }
//        }
//        ParallelAnimation {
//            NumberAnimation { target: perCamera; property: "y"; to: 0; duration: 4000 }
//        }
//        ParallelAnimation {
//            NumberAnimation { target: perCamera; property: "y"; to: -200; duration: 4000 }
//        }
//        ParallelAnimation {
//            NumberAnimation { target: perCamera; property: "y"; to: 0; duration: 4000 }
//        }
//    }

    Model {
        source: "#Cube"
        rotation: Qt.vector3d(45, 45, 22.5)  //顺时针
        materials: DefaultMaterial {
            diffuseColor: "#a8171a"
        }
    }

    Model {
        y: 100
        source: "#Cone"
        materials: DefaultMaterial {
            diffuseColor: "#17a81a"
        }
    }

    Model {
        x: -200
        source: "#Sphere"
        materials: DefaultMaterial {
            diffuseColor: "#09102b"
        }
    }

    // 创建地板
    Model {
        id: floorModel
        source: "#Rectangle"
        y:-100
        scale: Qt.vector3d(30 ,30, 30) // 调整地板的大小
        materials: DefaultMaterial{
            diffuseColor: Qt.rgba(0.4, 0.5, 0.6,1.0)
            }
        rotation: Qt.vector3d(90, 0, 0)// 将地板旋转至水平方向
    }

    Node {
        id: car01_obj
        rotationOrder: Node.XYZr
        orientation: Node.RightHanded

        Model {
            x: 700
            y:-90
            id: car
            objectName: "car"
            rotationOrder: Node.XYZr
            orientation: Node.RightHanded
            source: "qrc:/obj/car.mesh"
            rotation: Qt.vector3d(270, 0, 0)
            pickable: true

            DefaultMaterial {
                id: node02___Default_material
                diffuseColor: "#ffbebebe"
            }
            PrincipledMaterial {
                 id: node02___PrincipledMaterial
                        baseColor: "green";
                        metalness: 0.8
                        roughness: 0.3
                        opacity: 0.5
                    }
            materials: [
                node02___Default_material
//                node02___PrincipledMaterial
            ]
        }
    }

    Text {
        id: tips
        z:1
        x:startPos.x
        y:startPos.y
        text: "使用方向按键⬅➡控制旋转"
        color: "red"
        font.pixelSize: 25
        visible: (!oneclick)&&(result.objectHit)
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
