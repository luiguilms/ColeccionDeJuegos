//
//  ViewController.swift
//  LupaccaColeccionDeJuegos
//
//  Created by Luigui Lupacca on 24/10/23.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var juegos : [Juego] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

    }
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try juegos = context.fetch(Juego.fetchRequest())
            tableView.reloadData()
        }catch{
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell()
        let juego = juegos[indexPath.row]
        cell.textLabel?.text = juego.titulo
        cell.imageView?.image = UIImage(data: (juego.imagen!))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let juego = juegos[indexPath.row]
        performSegue(withIdentifier: "juegoSegue", sender: juego)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! JuegosViewController
        siguienteVC.juego = sender as? Juego
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                // Accede al contexto de Core Data
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                // Elimina el elemento de la matriz juegos y de Core Data
                let juego = juegos[indexPath.row]
                context.delete(juego)
                // Guarda los cambios en Core Data
                do {
                    try context.save()
                } catch {
                    print("Error al guardar cambios en Core Data: \(error)")
                }
                // Actualiza la matriz juegos
                juegos.remove(at: indexPath.row)

                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }


        


}

