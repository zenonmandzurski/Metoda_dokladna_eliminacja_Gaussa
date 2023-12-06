//Metody Numeryczne projekt
//Wybrana metoda: Metoda dokładna, eliminacja Gaussa.
//Student: Radoslaw Borysewicz
//Numer indeksu: 163708
//Grupa Dziekańska: U2 Semestr

import Foundation

// Funkcja rozwiązująca układ równań metodą eliminacji Gaussa
func eliminacjaGaussa(A: [[Double]], B: [Double]) -> [Double] {
    var A = A // Kopia macierzy współczynników
    var B = B // Kopia wektora wynikowego
    let n = A.count // Liczba równań

    // Eliminacja współczynników
    for k in 0..<n - 1 {
        for i in k + 1..<n {
            let factor = A[i][k] / A[k][k]
            for j in k..<n {
                A[i][j] -= factor * A[k][j]
            }
            B[i] -= factor * B[k]
        }
    }

    // Rozwiązanie równań
    var X = [Double](repeating: 0, count: n) // Lista rozwiązań
    for i in stride(from: n - 1, through: 0, by: -1) {
        X[i] = B[i] / A[i][i]
        for j in stride(from: i + 1, to: n, by: 1) {
            X[i] -= A[i][j] * X[j] / A[i][i]
        }
    }

    return X // Zwraca listę rozwiązań
}

// Funkcja rozwiązująca układ równań odczytująca dane z pliku
func eliminacjaGaussaZPliku(nazwaPliku: String) -> [Double]? {
    // Sprawdza istnienie pliku i odczytuje dane
    if let fileURL = Bundle.main.url(forResource: nazwaPliku, withExtension: "txt") {
        do {
            let data = try String(contentsOf: fileURL)
            let lines = data.components(separatedBy: .newlines)

            var A = [[Double]]()
            var B = [Double]()

            // Przetwarza linie pliku na macierz współczynników A i wektor wynikowy B
            for line in lines {
                let values = line.components(separatedBy: " ").compactMap { Double($0) }

                if values.count >= 2 {
                    let coefficients = Array(values[0..<values.count - 1])
                    let result = values.last ?? 0.0
                    A.append(coefficients)
                    B.append(result)
                }
            }

            // Wywołuje funkcję eliminacji Gaussa i zwraca wynik
            return eliminacjaGaussa(A: A, B: B)
        } catch {
            print("Błąd podczas odczytu pliku: \(error)")
            return nil
        }
    } else {
        print("Plik nie istnieje.")
        return nil
    }
}

// Wywołanie funkcji z pliku 'test.txt' i wyświetlenie wyniku
if let wynik = eliminacjaGaussaZPliku(nazwaPliku: "test") {
    print("Rozwiązania:", wynik)
}
