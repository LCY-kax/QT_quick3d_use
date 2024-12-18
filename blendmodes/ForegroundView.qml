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


View3D {
    //! [foreground]
    environment: SceneEnvironment {
        backgroundMode: SceneEnvironment.Transparent
    }
    //! [foreground]

    Node {
        id: orbiter

        NumberAnimation {
            target: orbiter
            property: "rotation.y"
            duration: 5000
            from: 0
            to: 360
            loops: Animation.Infinite
            running: true
        }

        DirectionalLight {
            brightness: 800
             color: "white"
        }

        PerspectiveCamera {
            z: -500
            x:-340
            y:230
        }
    }

    Model {
        id: cube1
        source: "#Cube"
        x: -50
        scale: Qt.vector3d(0.5, 0.5, 0.5)
        materials: AluminumMaterial {
            bump_amount: 5.0
        }
    }


    Model {
        id: cube2
        source: "#Cube"
        y: 150
        scale: Qt.vector3d(0.5, 0.5, 0.5)
        materials: [ FrostedGlassSinglePassMaterial {
                roughness: 0.1
                reflectivity_amount: 0.9
                glass_ior: 1.9
                glass_color: Qt.vector3d(0.85, 0.85, 0.9)
            }]
    }


    Model {
        id: cone1
        y: 70
        scale: Qt.vector3d(0.5, 0.5, 0.5)
        rotation.x: 45
        source: "#Cone"
        materials: CopperMaterial {}

        SequentialAnimation {
            NumberAnimation {
                target: cone1
                property: "y"
                duration: 3000
                easing.type: Easing.InOutQuad
                from:70
                to: 150
            }
            NumberAnimation {
                target: cone1
                property: "y"
                duration: 3000
                easing.type: Easing.InOutQuad
                from: 150
                to:70
            }
            running: true
            loops: -1
        }
    }

    Model {
        id: cylinder1
        x: 50
        scale: Qt.vector3d(0.5, 0.5, 0.5)
        source: "#Sphere"
        materials: SteelMilledConcentricMaterial {}
    }
}
