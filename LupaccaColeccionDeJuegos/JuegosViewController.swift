//
//  JuegosViewController.swift
//  LupaccaColeccionDeJuegos
//
//  Created by Luigui Lupacca on 24/10/23.
//

import UIKit

class JuegosViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    

    @IBAction func fotosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true,completion: nil)
    }
    @IBAction func camaraTapped(_ sender: Any) {
    }
    @IBOutlet weak var JuegoImageView: UIImageView!
    @IBOutlet weak var tituloTextField: UITextField!
    @IBAction func agregarTapped(_ sender: Any) {
        if juego != nil{
            juego!.titulo! = tituloTextField.text!
            juego!.imagen = JuegoImageView.image?.jpegData(compressionQuality: 0.50)
            juego!.categoria = selectedCategory
        }else{
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let juego = Juego(context: context)
            juego.titulo = tituloTextField.text
            juego.imagen = JuegoImageView.image?.jpegData(compressionQuality: 0.50)
            juego.categoria = selectedCategory
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    @IBAction func eliminarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(juego!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    @IBOutlet weak var eliminarBoton: UIButton!
    var imagePicker = UIImagePickerController()
    var juego:Juego? = nil
    
    @IBOutlet weak var categoriaPicker: UIPickerView!
    var categorias = ["Accion", "Terror", "Drama", "Infantil"]
    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        categoriaPicker.delegate = self
        categoriaPicker.dataSource = self

        if juego != nil {
                JuegoImageView.image = UIImage(data: (juego!.imagen!) as Data)
                tituloTextField.text = juego!.titulo
                agregarActualizarBoton.setTitle("Actualizar", for: .normal)

                // Configura la selección inicial del UIPickerView
                if let categoria = juego!.categoria, let index = categorias.firstIndex(of: categoria) {
                    categoriaPicker.selectRow(index, inComponent: 0, animated: false)
                    selectedCategory = categoria
                }
            } else {
                eliminarBoton.isHidden = true
            }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagenSeleccionada = info[.originalImage] as? UIImage
        JuegoImageView.image = imagenSeleccionada
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorias.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorias[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categorias[row]
    }

    

}
