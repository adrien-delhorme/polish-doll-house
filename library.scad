module rotate_origin(angles, origin) {
    translate(origin)
        rotate(angles)
            translate(-origin)
                children();
}
