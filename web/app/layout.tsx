import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Game of Life - Web Game',
  description: 'Defend against incoming spaceships and gliders in this interactive Game of Life web game',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>
        {children}
      </body>
    </html>
  )
}
