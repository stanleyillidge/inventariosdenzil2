const admin = require('firebase-admin');
const functions = require('firebase-functions');

admin.initializeApp(functions.config().firebase);

let firestore = admin.firestore();
let rtdatabase = admin.database().ref();
let database={};
// let batchArticulos = firestore.batch();
// let batchInventario = firestore.batch();
// let batchContadores = firestore.batch();

exports.sedes = functions.https.onRequest((req, res) => {
  rtdatabase.child('sedes').once("value", data => {
    const sedes = data.val();
    database['sedes'] = {};
    database['sedes'] = sedes;
    const keys = Object.keys(sedes);
    keys.forEach(key => {
      database['sedes'][key]['Buenos'] = 0;
      database['sedes'][key]['Malos'] = 0;
      database['sedes'][key]['Regulares'] = 0;
      let datos = {
          Buenos: 0,
          Malos: 0,
          Regulares: 0,
          cantidad: 0,
          imagen: (sedes[key]['imagen']!==undefined)?sedes[key]['imagen']:"/assets/shapes.svg",
          key: key,
          nombre: (sedes[key]['nombre']!==undefined)?sedes[key]['nombre']:'No tiene',
          descripcion: (sedes[key]['descripcion']!==undefined)?sedes[key]['descripcion']:'',
          codigo: (sedes[key]['codigo']!==undefined)?sedes[key]['codigo']:'',
      };
      functions.logger.info('datos',key,datos);
      firestore.collection('sedes').doc(key).set(datos);
    });
    res.send("Sedes Finalizó con Exito!");
  })
  .catch( errorObject => {
    functions.logger.error("The read sedes failed: " + errorObject.code);
  });
});
exports.ubicaciones = functions.https.onRequest((req, res) => {
  let batch = firestore.batch();
  rtdatabase.child('sedes').once("value", data => {
    const sedes = data.val();
    database['sedes'] = {};
    database['sedes'] = sedes;
    const keys = Object.keys(sedes);
    keys.forEach(key => {
      database['sedes'][key]['Buenos'] = 0;
      database['sedes'][key]['Malos'] = 0;
      database['sedes'][key]['Regulares'] = 0;
    });
  })
  .catch( errorObject => {
    functions.logger.error("The read sedes failed: " + errorObject.code);
  });
  rtdatabase.child('ubicaciones2').once("value", data => {
    const ubicaciones = data.val();
    database['ubicaciones'] = {};
    database['ubicaciones'] = ubicaciones;
    const keys = Object.keys(ubicaciones);
    keys.forEach(key => {
      database['ubicaciones'][key]['Buenos'] = 0;
      database['ubicaciones'][key]['Malos'] = 0;
      database['ubicaciones'][key]['Regulares'] = 0;
      const sedekey = (ubicaciones[key]['sede']!==undefined)?ubicaciones[key]['sede']:'No tiene';
      const sedeNombre = database['sedes'][sedekey]['nombre'];
      const ruta = 'sedes/'+sedekey+'/ubicaciones/'+key;
      let datos = {
        Buenos: 0,
        Malos: 0,
        Regulares: 0,
        cantidad: 0,
        imagen: (ubicaciones[key]['imagen']!==undefined)?ubicaciones[key]['imagen']:"/assets/shapes.svg",
        key: key,
        nombre: (ubicaciones[key]['nombre']!==undefined)?ubicaciones[key]['nombre']:'No tiene',
        descripcion: (ubicaciones[key]['descripcion']!==undefined)?ubicaciones[key]['descripcion']:'',
        codigo: (ubicaciones[key]['codigo']!==undefined)?ubicaciones[key]['codigo']:'',
        sede: sedekey,
        sedeNombre: sedeNombre,
      };
      functions.logger.log('ubicaciones',key,datos);
      batch.set(firestore.doc(ruta), datos);
      // firestore.collection('sedes').doc(sedekey)
      // .collection('ubicaciones').doc(key).set(datos);
    });
  })
  .then(()=> {
    return batch.commit().then(()=> {
      functions.logger.log('Contadores Termino');
      return res.send("Ubicaciones Finalizó con Exito!");
    }).catch((e)=>{ functions.logger.error("Error en batch Ubicaciones" + e); });
  })
  .catch( errorObject => {
    functions.logger.error("The read ubicaciones failed: " + errorObject.code);
  });
});
exports.subUbicaciones = functions.https.onRequest((req, res) => {
  let batch = firestore.batch();
  rtdatabase.child('sedes').once("value", data => {
    const sedes = data.val();
    database['sedes'] = {};
    database['sedes'] = sedes;
    const keys = Object.keys(sedes);
    keys.forEach(key => {
      database['sedes'][key]['Buenos'] = 0;
      database['sedes'][key]['Malos'] = 0;
      database['sedes'][key]['Regulares'] = 0;
    });
  })
  .catch( errorObject => {
    functions.logger.error("The read sedes failed: " + errorObject.code);
  });
  rtdatabase.child('ubicaciones2').once("value", data => {
    const ubicaciones = data.val();
    database['ubicaciones'] = {};
    database['ubicaciones'] = ubicaciones;
    const keys = Object.keys(ubicaciones);
    keys.forEach(key => {
      database['ubicaciones'][key]['Buenos'] = 0;
      database['ubicaciones'][key]['Malos'] = 0;
      database['ubicaciones'][key]['Regulares'] = 0;
    });
  })
  .catch( errorObject => {
    functions.logger.error("The read ubicaciones failed: " + errorObject.code);
  });
  rtdatabase.child('subUbicaciones2').once("value", data => {
    const subUbicaciones = data.val();
    database['subUbicaciones'] = {};
    database['subUbicaciones'] = subUbicaciones;
    const keys = Object.keys(subUbicaciones);
    keys.forEach(key => {
      database['subUbicaciones'][key]['Buenos'] = 0;
      database['subUbicaciones'][key]['Malos'] = 0;
      database['subUbicaciones'][key]['Regulares'] = 0;
      const sedekey = (subUbicaciones[key]['sede']!==undefined)?subUbicaciones[key]['sede']:'No tiene';
      const sedeNombre = database['sedes'][sedekey]['nombre'];
      const ubicacionkey = (subUbicaciones[key]['ubicacion']!==undefined)?subUbicaciones[key]['ubicacion']:'No tiene';
      const ubicacionNombre = database['ubicaciones'][ubicacionkey]['nombre'];
      const ruta = 'sedes/'+sedekey+'/ubicaciones/'+ubicacionkey+'/subUbicaciones/'+key;
      let datos = {
          Buenos: 0,
          Malos: 0,
          Regulares: 0,
          cantidad: 0,
          imagen: (subUbicaciones[key]['imagen']!==undefined)?subUbicaciones[key]['imagen']:"/assets/shapes.svg",
          key: key,
          nombre: (subUbicaciones[key]['nombre']!==undefined)?subUbicaciones[key]['nombre']:'No tiene',
          descripcion: (subUbicaciones[key]['descripcion']!==undefined)?subUbicaciones[key]['descripcion']:'',
          codigo: (subUbicaciones[key]['codigo']!==undefined)?subUbicaciones[key]['codigo']:'',
          sede: sedekey,
          sedeNombre: sedeNombre,
          ubicacion: ubicacionkey,
          ubicacionNombre: ubicacionNombre,
      };
      functions.logger.log('subUbicaciones',key,datos);
      batch.set(firestore.doc(ruta), datos);
      // firestore.collection('sedes').doc(sedekey)
      // .collection('ubicaciones').doc(ubicacionkey)
      // .collection('subUbicaciones').doc(key).set(datos);
    });
  })
  .then(()=> {
    return batch.commit().then(()=> {
      functions.logger.log('subUbicaciones Termino');
      return res.send("subUbicaciones Finalizó con Exito!");
    }).catch((e)=>{ functions.logger.error("Error en batch subUbicaciones" + e); });
  })
  .catch( errorObject => {
    functions.logger.error("The read ubicaciones failed: " + errorObject.code);
  });
});
exports.inventario = functions.https.onRequest(async (req, res) => {
  await rtdatabase.child('sedes').once("value", data => {
    const sedes = data.val();
    database['sedes'] = {};
    database['sedes'] = sedes;
    const keys = Object.keys(sedes);
    keys.forEach(key => {
      database['sedes'][key]['Buenos'] = 0;
      database['sedes'][key]['Malos'] = 0;
      database['sedes'][key]['Regulares'] = 0;
    });
  })
  .catch( errorObject => {
    functions.logger.error("The read sedes failed: " + errorObject.code);
  });
  await rtdatabase.child('ubicaciones2').once("value", data => {
    const ubicaciones = data.val();
    database['ubicaciones'] = {};
    database['ubicaciones'] = ubicaciones;
    const keys = Object.keys(ubicaciones);
    keys.forEach(key => {
      database['ubicaciones'][key]['Buenos'] = 0;
      database['ubicaciones'][key]['Malos'] = 0;
      database['ubicaciones'][key]['Regulares'] = 0;
    });
  })
  .catch( errorObject => {
    functions.logger.error("The read ubicaciones failed: " + errorObject.code);
  });
  await rtdatabase.child('subUbicaciones2').once("value", data => {
    const subUbicaciones = data.val();
    database['subUbicaciones'] = {};
    database['subUbicaciones'] = subUbicaciones;
    const keys = Object.keys(subUbicaciones);
    keys.forEach(key => {
      database['subUbicaciones'][key]['Buenos'] = 0;
      database['subUbicaciones'][key]['Malos'] = 0;
      database['subUbicaciones'][key]['Regulares'] = 0;
    });
  })
  .catch( errorObject => {
    functions.logger.error("The read ubicaciones failed: " + errorObject.code);
  });
  await rtdatabase.child('inventario2').once("value", data => {
    const articulos = data.val();
    database['inventario'] = {};
    database['inventario'] = articulos;
    const keys = Object.keys(articulos);
    const fin = keys.length;
    let conta = 0;
    let steper = 0;
    const step = 495;
    let contadores = {};
    let inventario = {};
    let articulost = {};
    let articulosUnicos = {};
    let articulosArray = [];
    let aArray = [];
    let inventarioArray = [];
    let iArray = [];
    let contadoresArray = [];
    let cArray = [];
    functions.logger.info('Fin',fin);

    keys.forEach(key => {
      // ---- config inicial -----
        const sedekey = (articulos[key]['sede']!==undefined)?articulos[key]['sede']:'No tiene';
        const sedeNombre = database['sedes'][sedekey]['nombre'];
        const ubicacionkey = (articulos[key]['ubicacion']!==undefined)?articulos[key]['ubicacion']:'No tiene';
        const ubicacionNombre = database['ubicaciones'][ubicacionkey]['nombre'];
        const subUbicacionkey = (articulos[key]['subUbicacion']!==undefined)?articulos[key]['subUbicacion']:'No tiene';
        const subUbicacionNombre = database['subUbicaciones'][subUbicacionkey]['nombre'];
        let datos = {
          articulo: (articulos[key]['articulo']!==undefined)?articulos[key]['articulo']:'No tiene',
          cantidad: (articulos[key]['cantidad']!==undefined)?articulos[key]['cantidad']:0,
          creacion: (articulos[key]['creacion']!==undefined)?articulos[key]['creacion']:'No tiene',
          descripcion: (articulos[key]['descripcion']!==undefined)?articulos[key]['descripcion']:'No tiene',
          disponibilidad: (articulos[key]['disponibilidad']!==undefined)?articulos[key]['disponibilidad']:'No tiene',
          estado: (articulos[key]['estado']!==undefined)?articulos[key]['estado']:'No tiene',
          etiqueta: (articulos[key]['etiqueta']!==undefined)?articulos[key]['etiqueta']:'No tiene',
          etiquetaId: (articulos[key]['etiquetaId']!==undefined)?articulos[key]['etiquetaId']:'No tiene',
          fechaEtiqueta: (articulos[key]['fechaEtiqueta']!==undefined)?articulos[key]['fechaEtiqueta']:'No tiene',
          ingreso: (articulos[key]['ingreso']!==undefined)?articulos[key]['ingreso']:'No tiene',
          observaciones: (articulos[key]['observaciones']!==undefined)?articulos[key]['observaciones']:'No tiene',
          serie: (articulos[key]['serie']!==undefined)?articulos[key]['serie']:'No tiene',
          tipo: (articulos[key]['tipo']!==undefined)?articulos[key]['tipo']:'No tiene',
          valor: (articulos[key]['valor']!==undefined)?articulos[key]['valor']:0,
          imagen: (articulos[key]['imagen']!==undefined)?articulos[key]['imagen']:"/assets/shapes.svg",
          key: key,
          nombre: (articulos[key]['nombre']!==undefined)?articulos[key]['nombre']:'No tiene',
          codigo: (articulos[key]['codigo']!==undefined)?articulos[key]['codigo']:'No tiene',
          sede: sedekey,
          sedeNombre: sedeNombre,
          ubicacion: ubicacionkey,
          ubicacionNombre: ubicacionNombre,
          subUbicacion: subUbicacionkey,
          subUbicacionNombre: subUbicacionNombre,
        };
        const rutaSede = 'sedes/'+sedeNombre;
        const rutaUbicacion = rutaSede+'/ubicaciones/'+ubicacionNombre;
        const rutaSubUbicacion = rutaUbicacion+'/subUbicaciones/'+subUbicacionNombre;
        const rutaInventario = rutaSubUbicacion+'/inventario/'+datos.nombre;
        const rutaArticulos = rutaInventario+'/articulos/'+datos.nombre;

        if(contadores[rutaSede] === undefined){
          contadores[rutaSede] = {
            Buenos:0,
            Malos:0,
            Regulares:0,
            cantidad: 0,
          };
        }
        if(contadores[rutaUbicacion] === undefined){
          contadores[rutaUbicacion] = {
            Buenos:0,
            Malos:0,
            Regulares:0,
            cantidad: 0,
          };
        }
        if(contadores[rutaSubUbicacion] === undefined){
          contadores[rutaSubUbicacion] = {
            Buenos:0,
            Malos:0,
            Regulares:0,
            cantidad: 0,
          };
        }
        if(inventario[rutaInventario] === undefined){
          inventario[rutaInventario] = {
            Buenos: 0,
            Malos: 0,
            Regulares: 0,
            cantidad: 0,
            nombre: datos.nombre,
            key: key,
            sede: datos.sede,
            sedeNombre: datos.sedeNombre,
            ubicacion: datos.ubicacion,
            ubicacionNombre: datos.ubicacionNombre,
            subUbicacion: datos.subUbicacion,
            subUbicacionNombre: datos.subUbicacionNombre,
          };
        }
        if(articulost[rutaArticulos] === undefined){
          articulost[rutaArticulos] = datos;
        }
        if(articulosUnicos[datos.articulo] === undefined){
          articulosUnicos[datos.articulo] = {
            key: datos.articulo,
            nombre: datos.nombre,
            cantidad: 1,
            tipo: 'no consumible',
          };
        } else {
          articulosUnicos[datos.articulo].cantidad += 1;
        }
        switch (datos.estado) {
          case "Bueno":
            contadores[rutaSede].Buenos += 1;
            contadores[rutaSede].cantidad += 1;
            contadores[rutaUbicacion].Buenos += 1;
            contadores[rutaUbicacion].cantidad += 1;
            contadores[rutaSubUbicacion].Buenos += 1;
            contadores[rutaSubUbicacion].cantidad += 1;
            inventario[rutaInventario].Buenos += 1;
            inventario[rutaInventario].cantidad += 1;
            break;
          case "Malo":
            contadores[rutaSede].Malos += 1;
            contadores[rutaSede].cantidad += 1;
            contadores[rutaUbicacion].Malos += 1;
            contadores[rutaUbicacion].cantidad += 1;
            contadores[rutaSubUbicacion].Malos += 1;
            contadores[rutaSubUbicacion].cantidad += 1;
            inventario[rutaInventario].Malos += 1;
            inventario[rutaInventario].cantidad += 1;
            break;
          case "Regular":
            contadores[rutaSede].Regulares += 1;
            contadores[rutaSede].cantidad += 1;
            contadores[rutaUbicacion].Regulares += 1;
            contadores[rutaUbicacion].cantidad += 1;
            contadores[rutaSubUbicacion].Regulares += 1;
            contadores[rutaSubUbicacion].cantidad += 1;
            inventario[rutaInventario].Regulares += 1;
            inventario[rutaInventario].cantidad += 1;
            break;
          default:
            break;
        }
      // -------------------------
      conta += 1;
      steper += 1;
      if(Number.isInteger(steper/step)){
        functions.logger.info('Articulo',conta,'de',fin);

        iArray.push(inventario);
        inventarioArray.push(batchs(inventario,'inventario'));
        functions.logger.info('Objeto de inventario parcial a ser enviado', inventario);

        aArray.push(articulost);
        articulosArray.push(batchs(articulost,'articulos'));
        functions.logger.info('Objeto de articulos parcial a ser enviado', articulost);

        cArray.push(contadores);
        contadoresArray.push(batchs(contadores,'contadores'));
        functions.logger.info('Objeto de contadores parcial a ser enviado', contadores);

        // contadores = {};
        // inventario = {};
        articulost = {};
      }
      // functions.logger.log('Articulo',conta,'de',fin);
      if(conta === fin){
        functions.logger.log('Articulo',conta,'de',fin);
        firestore.collection('articulosUnicos2').add(articulosUnicos);

        Promise.all(inventarioArray).then(() => {
          functions.logger.info('Fin de escritura de todo el Inventario');
          return
        }).catch((e)=> {
          functions.logger.error("La escritura de todo el Inventario failed: " + errorObject.code);
          res.send("La escritura de todo el Inventario failed:" + e);
        });
        Promise.all(articulosArray).then(() => {
          functions.logger.info('Fin de escritura de todos los articulos');
          return
        }).catch((e)=> {
          functions.logger.error("La escritura de de todos los articulos failed: " + errorObject.code);
          res.send("La escritura de de todos los articulos failed:" + e);
        });
        Promise.all(contadoresArray).then(() => {
          functions.logger.info('Fin de escritura de todos los contadores');
          res.send("Todas las funciones finalizarón con Exito!");
          return
        }).catch((e)=> {
          functions.logger.error("La escritura de todos los contadores failed: " + errorObject.code);
          res.send("La escritura de todos los contadores failed:" + e);
        });
      }
    });
    /* for (let index = inicio; index < fintemp; index++) {
      const sedekey = (articulos[keys[index]]['sede']!==undefined)?articulos[keys[index]]['sede']:'No tiene';
      const sedeNombre = database['sedes'][sedekey]['nombre'];
      const ubicacionkey = (articulos[keys[index]]['ubicacion']!==undefined)?articulos[keys[index]]['ubicacion']:'No tiene';
      const ubicacionNombre = database['ubicaciones'][ubicacionkey]['nombre'];
      const subUbicacionkey = (articulos[keys[index]]['subUbicacion']!==undefined)?articulos[keys[index]]['subUbicacion']:'No tiene';
      const subUbicacionNombre = database['subUbicaciones'][subUbicacionkey]['nombre'];
      let datos = {
        articulo: (articulos[keys[index]]['articulo']!==undefined)?articulos[keys[index]]['articulo']:'No tiene',
        cantidad: (articulos[keys[index]]['cantidad']!==undefined)?articulos[keys[index]]['cantidad']:0,
        creacion: (articulos[keys[index]]['creacion']!==undefined)?articulos[keys[index]]['creacion']:'No tiene',
        descripcion: (articulos[keys[index]]['descripcion']!==undefined)?articulos[keys[index]]['descripcion']:'No tiene',
        disponibilidad: (articulos[keys[index]]['disponibilidad']!==undefined)?articulos[keys[index]]['disponibilidad']:'No tiene',
        estado: (articulos[keys[index]]['estado']!==undefined)?articulos[keys[index]]['estado']:'No tiene',
        etiqueta: (articulos[keys[index]]['etiqueta']!==undefined)?articulos[keys[index]]['etiqueta']:'No tiene',
        etiquetaId: (articulos[keys[index]]['etiquetaId']!==undefined)?articulos[keys[index]]['etiquetaId']:'No tiene',
        fechaEtiqueta: (articulos[keys[index]]['fechaEtiqueta']!==undefined)?articulos[keys[index]]['fechaEtiqueta']:'No tiene',
        ingreso: (articulos[keys[index]]['ingreso']!==undefined)?articulos[keys[index]]['ingreso']:'No tiene',
        observaciones: (articulos[keys[index]]['observaciones']!==undefined)?articulos[keys[index]]['observaciones']:'No tiene',
        serie: (articulos[keys[index]]['serie']!==undefined)?articulos[keys[index]]['serie']:'No tiene',
        tipo: (articulos[keys[index]]['tipo']!==undefined)?articulos[keys[index]]['tipo']:'No tiene',
        valor: (articulos[keys[index]]['valor']!==undefined)?articulos[keys[index]]['valor']:0,
        imagen: (articulos[keys[index]]['imagen']!==undefined)?articulos[keys[index]]['imagen']:"/assets/shapes.svg",
        key: keys[index],
        nombre: (articulos[keys[index]]['nombre']!==undefined)?articulos[keys[index]]['nombre']:'No tiene',
        codigo: (articulos[keys[index]]['codigo']!==undefined)?articulos[keys[index]]['codigo']:'No tiene',
        sede: sedekey,
        sedeNombre: sedeNombre,
        ubicacion: ubicacionkey,
        ubicacionNombre: ubicacionNombre,
        subUbicacion: subUbicacionkey,
        subUbicacionNombre: subUbicacionNombre,
      };
      const rutaSede = 'sedes/'+sedekey;
      const rutaUbicacion = rutaSede+'/ubicaciones/'+ubicacionkey;
      const rutaSubUbicacion = rutaUbicacion+'/subUbicaciones/'+subUbicacionkey;
      const rutaInventario = rutaSubUbicacion+'/inventario/'+datos.articulo;
      const rutaArticulos = rutaInventario+'/articulos/'+datos.key;

      batchArticulos.set(firestore.doc(rutaArticulos), datos);

      if(contadores[rutaSede]===undefined){
        contadores[rutaSede] = {
          Buenos:0,
          Malos:0,
          Regulares:0,
          cantidad: 0,
        };
      }
      if(contadores[rutaUbicacion]===undefined){
        contadores[rutaUbicacion] = {
          Buenos:0,
          Malos:0,
          Regulares:0,
          cantidad: 0,
        };
      }
      if(contadores[rutaSubUbicacion]===undefined){
        contadores[rutaSubUbicacion] = {
          Buenos:0,
          Malos:0,
          Regulares:0,
          cantidad: 0,
        };
      }
      if(inventario[rutaInventario]===undefined){
        inventario[rutaInventario] = {
          Buenos:0,
          Malos:0,
          Regulares:0,
          cantidad:0,
          nombre:'',
          key:keys[index],
        };
      }
      switch (datos.estado) {
        case "Bueno":
          contadores[rutaSede].Buenos += 1;
          contadores[rutaSede].cantidad += 1;
          contadores[rutaUbicacion].Buenos += 1;
          contadores[rutaUbicacion].cantidad += 1;
          contadores[rutaSubUbicacion].Buenos += 1;
          contadores[rutaSubUbicacion].cantidad += 1;
          inventario[rutaInventario].Buenos += 1;
          inventario[rutaInventario].cantidad += 1;
          break;
        case "Malo":
          contadores[rutaSede].Malos += 1;
          contadores[rutaSede].cantidad += 1;
          contadores[rutaUbicacion].Malos += 1;
          contadores[rutaUbicacion].cantidad += 1;
          contadores[rutaSubUbicacion].Malos += 1;
          contadores[rutaSubUbicacion].cantidad += 1;
          inventario[rutaInventario].Malos += 1;
          inventario[rutaInventario].cantidad += 1;
          break;
        case "Regular":
          contadores[rutaSede].Regulares += 1;
          contadores[rutaSede].cantidad += 1;
          contadores[rutaUbicacion].Regulares += 1;
          contadores[rutaUbicacion].cantidad += 1;
          contadores[rutaSubUbicacion].Regulares += 1;
          contadores[rutaSubUbicacion].cantidad += 1;
          inventario[rutaInventario].Regulares += 1;
          inventario[rutaInventario].cantidad += 1;
          break;
        default:
          break;
      }
      conta +=1;
      functions.logger.log('Articulo',conta,'de',fintemp);
      if(conta === fintemp){
        functions.logger.info('Contadores',contadores);
        functions.logger.info('Inventario',inventario);
        const contadoreskeys = Object.keys(contadores);
        const inventariokeys = Object.keys(inventario);
        contadoreskeys.forEach(key => {
          batchContadores.update(firestore.doc(key), contadores[key]);
        });
        inventariokeys.forEach(key => {
          batchInventario.set(firestore.doc(key), inventario[key]);
        });

        batchInventario.commit().then(()=> {
          functions.logger.log('Inventario Agregado');
          return batchArticulos.commit().then(()=> {
            functions.logger.log('Articulos Agregados');
            return batchContadores.commit().then(()=> {
              functions.logger.log('Contadores Termino');
              return res.send("Inventarios Finalizó con Exito!");
            }).catch((e)=>{
              functions.logger.error("Error en batchContadores" + e);
              res.send("Error en batchContadores" + e); });
          }).catch((e)=>{
            functions.logger.error("Error en batchArticulos" + e);
            res.send("Error en batchArticulos" + e); });
        }).catch((e)=>{
          functions.logger.error("Error en batchInventario" + e);
          res.send("Error en batchInventario" + e);
        });
      }
    } */
  })
  .catch( errorObject => {
    functions.logger.error("The read inventario2 failed: " + errorObject.code);
    res.send("The read inventario2 failed:" + e);
  });
});
//6835
function batchs(array,tipo){
  let batch = firestore.batch();
  return new Promise((resolve, reject) => {
    functions.logger.info('Batch',tipo,array);
    const keys = Object.keys(array);
    switch (tipo) {
      case 'contadores':
        keys.forEach(key => {
          batch.update(firestore.doc(key), array[key]);
        });
        break;
      case 'inventario':
        keys.forEach(key => {
          batch.update(firestore.doc(key), array[key]);
        });
        break;
      case 'articulos':
        keys.forEach(key => {
          batch.set(firestore.doc(key), array[key]);
        });
        break;
      default:
        break;
    }
    batch.commit().then(()=> {
      functions.logger.log(tipo,'Termino');
      resolve(tipo,"Finalizó con Exito!");
      return;
    }).catch((e)=>{
      functions.logger.error("Error en batch " + tipo,e);
      reject(e);
    });
    return;
  });
}