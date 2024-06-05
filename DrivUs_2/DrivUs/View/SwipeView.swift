//
//  SwipeView.swift
//  DrivUs
//
//  Created by Natalie Schmitzberger on 02.04.24.
//

import SwiftUI
import MapKit

struct SwipeView: View {
    @ObservedObject var viewModelRides = ViewModel_Rides()
    @ObservedObject var viewModelUser = ViewModel_User()
    @ObservedObject var viewModelSwipes = ViewModel_Swipes()
    @ObservedObject var viewModelMatches = ViewModel_Matches()
    
    @State private var showSwipeByIndex: Int = 0
    @State private var isLoading = true
    
    @StateObject var locationManager = LocationManager()
    @State var userLocations: [UserLocation] = []
    @State var route: MKRoute?
    @State var routeDisplaying = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    
    var body: some View {
         ZStack {
             VStack() {
                 if viewModelSwipes.isLoading {
                     ProgressView()
                 } else {
                     // Check if anything exists
                     
                     let user = viewModelUser.currUser
                     let swipes = viewModelSwipes.swipes
                     let userSwipes = swipes.filter { $0.firstUserId == user.id || $0.secondUserId == user.id }
                     
                     if let mySwipe = userSwipes.safeElement(at: showSwipeByIndex) {
                         Text("firstId: \(mySwipe.firstUserId)")
                         Text("secId: \(mySwipe.secondUserId)")
                         
                         Color.drivusBlue.overlay(
                             VStack {
                                 // Buttons
                                 HStack(spacing: 100) {
                                     Button(action: {
                                         rejectRide()
                                     }) {
                                         Image(systemName: "xmark")
                                             .padding()
                                             .background(Color.white)
                                             .foregroundColor(.black)
                                             .clipShape(Circle())
                                     }
                                     
                                     Button(action: {
                                         acceptSwipe(mySwipe)
                                     }) {
                                         Image(systemName: "checkmark")
                                             .padding()
                                             .background(Color.white)
                                             .foregroundColor(.black)
                                             .clipShape(Circle())
                                     }
                                 }
                                 .padding(.top, 5)
                                 .background(Color.drivusBlue)
                             }
                         )
                     }
                     
                     /*
                     if let swipe = viewModelSwipes.getSwipes()[safe: showSwipeByIndex] {
                         if let rideByCurrSwipe = viewModelRides.fetchRideById(swipe.rideId),
                            let nameOfMatchPerson = viewModelUser.getUserById(id: rideByCurrSwipe.user_id) {
                     
                             Text("showing swipe")
                             Text("firstUser: \(swipe.firstUserId)")
                             Text("secUser: \(swipe.secondUserId)")
                             
                             MapView(sp_latitude: rideByCurrSwipe.startpunkt_latitude, sp_longitude: rideByCurrSwipe.startpunkt_longitude, ep_latitude: rideByCurrSwipe.endpunkt_latitude, ep_longitude: rideByCurrSwipe.endpunkt_longitude)
                             
                             Color.drivusBlue.overlay(
                                 VStack {
                                     // Buttons
                                     HStack(spacing: 100) {
                                         Button(action: {
                                             rejectRide()
                                         }) {
                                             Image(systemName: "xmark")
                                                 .padding()
                                                 .background(Color.white)
                                                 .foregroundColor(.black)
                                                 .clipShape(Circle())
                                         }
                                         
                                         Button(action: {
                                             acceptSwipe(swipe)
                                         }) {
                                             Image(systemName: "checkmark")
                                                 .padding()
                                                 .background(Color.white)
                                                 .foregroundColor(.black)
                                                 .clipShape(Circle())
                                         }
                                     }
                                     .padding(.top, 5)
                                     .background(Color.drivusBlue)
                                     
                                     Text("\(rideByCurrSwipe.startpunkt_ort) - \(rideByCurrSwipe.endpunkt_ort)")
                                         .padding(.top, 20)
                                         .foregroundColor(.white)
                                         .kerning(7)
                                     
                                     Text(nameOfMatchPerson.name)
                                         .padding(5)
                                         .foregroundColor(.white)
                                 }
                                 .frame(width: UIScreen.main.bounds.width)
                                 .animation(.easeInOut, value: showSwipeByIndex)
                                 .transition(.slide)
                                 .padding(.bottom, 10)
                                 .background(Color.drivusBlue)
                                 .frame(height: UIScreen.main.bounds.height * 1.5)
                                 .cornerRadius(20)
                                 .shadow(color: .white, radius: 15, x: -0, y: -5)
                                 .frame(width: UIScreen.main.bounds.width)
                                 .gesture(
                                     DragGesture()
                                         .onEnded { gesture in
                                             if gesture.translation.width < -100 {
                                                 // Swipe Left
                                                 rejectRide()
                                             } else if gesture.translation.width > 100 {
                                                 // Swipe Right
                                                 acceptSwipe(swipe)
                                             }
                                         }
                                 )
                                 .animation(.easeInOut, value: showSwipeByIndex)
                                 .transition(.slide)
                                 .frame(height: UIScreen.main.bounds.height / 3)
                                 .indexViewStyle(.page(backgroundDisplayMode: .never))
                             )
                             
                         } else {
                             Text("No swipes found")
                                 .padding()
                                 .foregroundColor(.white)
                         }
                     } else {
                         Text("No swipes found")
                             .padding()
                             .foregroundColor(.white)
                     }
                      */
                 }
                 
                 Spacer()
             }
             .frame(width: UIScreen.main.bounds.width)
             .transition(.slide)
             .onAppear {
                 fetchSwipes()
             }
         }
         .frame(maxWidth: .infinity, maxHeight: .infinity)
         .padding(.bottom, 20)
    }
    
    private func fetchSwipes() {
        viewModelSwipes.fetchSwipes()
        isLoading = false
    }
    
    private func acceptSwipe(_ swipe: SwipeObject) {
        viewModelSwipes.acceptSwipe(swipeId: swipe.id, acceptRide: true, userId: ViewModel_User().getCurrUser().id)
        showSwipeByIndex += 1
    }
    
    private func rejectRide() {
        showSwipeByIndex += 1
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 48.2590, longitude: 14.2439)
    }
}

struct UserLocation: Identifiable, Hashable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UserLocation, rhs: UserLocation) -> Bool {
        return lhs.id == rhs.id
    }
}

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    let sp_latitude: Double
    let sp_longitude: Double
    let ep_latitude: Double
    let ep_longitude: Double
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                                        latitudinalMeters: 10000000, longitudinalMeters: 5000000)
        mapView.setRegion(region, animated: true)
        
        let newHeight = UIScreen.main.bounds.height / 2
        let newWidth = UIScreen.main.bounds.width / 3
        mapView.frame = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        
        let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: sp_latitude, longitude: sp_longitude))
        let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: ep_latitude, longitude: ep_longitude))
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: p1)
        request.destination = MKMapItem(placemark: p2)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            DispatchQueue.main.async {
                guard let route = response?.routes.first, error == nil else { return }
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                let annotations = [p1, p2].compactMap { MKPlacemark(placemark: $0) }
                mapView.addAnnotations(annotations)
            }
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the view
    }
}

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}
