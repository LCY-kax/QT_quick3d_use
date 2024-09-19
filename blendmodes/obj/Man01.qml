import QtQuick3D 1.12
import QtQuick 2.12

Node {
    id: man01_obj
    rotationOrder: Node.XYZr
    orientation: Node.RightHanded


    Model {
        id: man
        rotationOrder: Node.XYZr
        orientation: Node.RightHanded
        source: "meshes/man.mesh"

        DefaultMaterial {
            id: node01___Default_material
            diffuseColor: "#ffbebebe"
        }
        materials: [
            node01___Default_material
        ]
    }
}
